<#
.NOTES
Updated by Justin Beeden
V1.0 11.25.2013
    I have updated the original script by parameterizing it and adding support for Exchange 2013, including the option to include 2013 Health mailboxes. 
    Original script written by Rob Campbell
        http://blogs.technet.com/b/heyscriptingguy/archive/2011/03/02/use-powershell-to-track-email-messages-in-exchange-server.aspx
.SYNOPSIS
Checks Message Tracking Logs and pulls message statistics for an Exchange Organization.  Works on Exchange 2007 and later.
By default does not include messages for the Exchange 2013 Health Mailboxes, use the Include2013HealthMailboxes to include them in report.
.DESCRIPTION
Checks Message Tracking Logs and pulls message statistics for an Exchange Organization.  Works on Exchange 2007 and later.
By default does not include messages for the Exchange 2013 Health Mailboxes, use the Include2013HealthMailboxes to include them in report.
.PARAMETER DaysToGoBack
Specifies the amount of days to go back and search through the Message Tracking Logs.
.PARAMETER IncludeDistListStats
Optional parameter that will add an additional exported csv containing statistcics for Distribution List usage.
.PARAMETER Include2013HealthMailboxes
Optional parameter that will include the Exchange 2013 Health Mailboxes used by Managed Availabilty in the exported csv report.
.EXAMPLE
PS> .\GetMessageStatsToFile.ps1 -DaysToGoBack 30
Searches the past 30 days of Message Tracking Logs. Message Trackign logs are kept for 30 days by default on all transport servers.
.EXAMPLE
PS> .\GetMessageStatsToFile.ps1 -DaysToGoBack 15 -IncludeDistListStats
Searches the past 15 days of Message Tracking Logs. Also exports optional DistListStats csv.
#>

#Requires -version 2.0

Param(
    [Parameter(Position=0, Mandatory = $true,
    HelpMessage="Enter the number of days to go back and search message tracking log files.")]
    [int]$DaysToGoBack,

    [Parameter(Mandatory = $false)]
    [switch]$IncludeDistListStats,

    [Parameter(Mandatory = $false)]
    [switch]$Include2013HealthMailboxes
)
$rundate = $(Get-Date).toshortdatestring()
$startdate = $((Get-Date).adddays(-$DaysToGoBack)).toshortdatestring()

$outfile_date = ([datetime]$rundate).tostring("yyyy_MM_dd") 
$outfile = "$DaysToGoBack" + "DaysMessageStats_" + $outfile_date + ".csv"
 
$dloutfile = "DistListStats_" + $outfile_date +".csv"
 
$accepted_domains = Get-EXLAcceptedDomain |Foreach {$_.domainname.domain} 
[regex]$dom_rgx = "`(?i)(?:" + (($accepted_domains |% {"@" + [regex]::escape($_)}) -join "|") + ")$" 
 
$mbx_servers = Get-EXLExchangeServer |Where {$_.serverrole -match "Mailbox"}|Foreach {$_.fqdn} 
[regex]$mbx_rgx = "`(?i)(?:" + (($mbx_servers |Foreach {"@" + [regex]::escape($_)}) -join "|") + ")\>$" 
 
$msgid_rgx = "^\<.+@.+\..+\>$" 
 
$hts = Get-EXLTransportServer -WarningAction SilentlyContinue | Foreach {$_.name} 
 
$exch_addrs = @{} 
$msgrec = @{} 
$bytesrec = @{} 
$msgrec_exch = @{} 
$bytesrec_exch = @{} 
$msgrec_smtpext = @{} 
$bytesrec_smtpext = @{} 
$total_msgsent = @{} 
$total_bytessent = @{} 
$unique_msgsent = @{} 
$unique_bytessent = @{} 
$total_msgsent_exch = @{} 
$total_bytessent_exch = @{} 
$unique_msgsent_exch = @{} 
$unique_bytessent_exch = @{} 
$total_msgsent_smtpext = @{} 
$total_bytessent_smtpext = @{} 
$unique_msgsent_smtpext=@{} 
$unique_bytessent_smtpext = @{} 
$dl = @{} 
 
$obj_table = { 
@" 
        Date = $rundate 
        User = $($address.split("@")[0]) 
        Domain = $($address.split("@")[1]) 
        Sent Total = $(0 + $total_msgsent[$address]) 
        Sent MB Total = $("{0:F2}" -f $($total_bytessent[$address]/1mb)) 
        Received Total = $(0 + $msgrec[$address]) 
        Received MB Total = $("{0:F2}" -f $($bytesrec[$address]/1mb)) 
        Sent Internal = $(0 + $total_msgsent_exch[$address]) 
        Sent Internal MB = $("{0:F2}" -f $($total_bytessent_exch[$address]/1mb)) 
        Sent External = $(0 + $total_msgsent_smtpext[$address]) 
        Sent External MB = $("{0:F2}" -f $($total_bytessent_smtpext[$address]/1mb)) 
        Received Internal = $(0 + $msgrec_exch[$address]) 
        Received Internal MB = $("{0:F2}" -f $($bytesrec_exch[$address]/1mb)) 
        Received External = $(0 + $msgrec_smtpext[$address]) 
        Received External MB = $("{0:F2}" -f $($bytesrec_smtpext[$address]/1mb)) 
        Sent Unique Total = $(0 + $unique_msgsent[$address]) 
        Sent Unique MB Total = $("{0:F2}" -f $($unique_bytessent[$address]/1mb)) 
        Sent Internal Unique  = $(0 + $unique_msgsent_exch[$address])  
        Sent Internal Unique MB = $("{0:F2}" -f $($unique_bytessent_exch[$address]/1mb)) 
        Sent External  Unique = $(0 + $unique_msgsent_smtpext[$address]) 
        Sent External Unique MB = $("{0:F2}" -f $($unique_bytessent_smtpext[$address]/1mb)) 
"@ 
} 
 
$props = $obj_table.ToString().Split("`n")|% {if ($_ -match "(.+)="){$matches[1].trim()}} 
 
$stat_recs = @() 
 
function time_pipeline { 
    param ($increment  = 1000) 
        begin{$i=0;$timer = [diagnostics.stopwatch]::startnew()} 
        process { 
            $i++ 
            if (!($i % $increment)){Write-host “`rProcessed $i in $($timer.elapsed.totalseconds) seconds” -nonewline} 
            $_ 
            } 
        end { 
            write-host “`rProcessed $i log records in $($timer.elapsed.totalseconds) seconds” 
            Write-Host "   Average rate: $([int]($i/$timer.elapsed.totalseconds)) log recs/sec." 
            } 
} 
 
foreach ($ht in $hts){ 
 
    Write-Host "`nStarted processing $ht" 
 
    get-EXLmessagetrackinglog -Server $ht -Start "$startdate" -End "$rundate 11:59:59 PM" -resultsize unlimited | 
    time_pipeline |%{ 
     
    If ($Include2013HealthMailboxes){ 
        if ($_.eventid -eq "DELIVER" -and $_.source -eq "STOREDRIVER"){ 
     
            if ($_.messageid -match $mbx_rgx -and $_.sender -match $dom_rgx) { 
             
                $total_msgsent[$_.sender] += $_.recipientcount 
                $total_bytessent[$_.sender] += ($_.recipientcount * $_.totalbytes) 
                $total_msgsent_exch[$_.sender] += $_.recipientcount 
                $total_bytessent_exch[$_.sender] += ($_.totalbytes * $_.recipientcount) 
         
                foreach ($rcpt in $_.recipients){ 
                $exch_addrs[$rcpt] ++ 
                $msgrec[$rcpt] ++ 
                $bytesrec[$rcpt] += $_.totalbytes 
                $msgrec_exch[$rcpt] ++ 
                $bytesrec_exch[$rcpt] += $_.totalbytes 
                } 
             
            }  
            else { 
                if ($_.messageid -match $msgid_rgx){ 
                        foreach ($rcpt in $_.recipients){ 
                            $msgrec[$rcpt] ++ 
                            $bytesrec[$rcpt] += $_.totalbytes 
                            $msgrec_smtpext[$rcpt] ++ 
                            $bytesrec_smtpext[$rcpt] += $_.totalbytes 
                        } 
                    } 
         
                } 
                 
        }
    }
    Else {
          if ($_.eventid -eq "DELIVER" -and $_.source -eq "STOREDRIVER" -and $_.Recipients -notmatch "HealthMailbox"){ 
     
            if ($_.messageid -match $mbx_rgx -and $_.sender -match $dom_rgx) { 
             
                $total_msgsent[$_.sender] += $_.recipientcount 
                $total_bytessent[$_.sender] += ($_.recipientcount * $_.totalbytes) 
                $total_msgsent_exch[$_.sender] += $_.recipientcount 
                $total_bytessent_exch[$_.sender] += ($_.totalbytes * $_.recipientcount) 
         
                foreach ($rcpt in $_.recipients){ 
                $exch_addrs[$rcpt] ++ 
                $msgrec[$rcpt] ++ 
                $bytesrec[$rcpt] += $_.totalbytes 
                $msgrec_exch[$rcpt] ++ 
                $bytesrec_exch[$rcpt] += $_.totalbytes 
                } 
             
            }  
            else { 
                if ($_.messageid -match $msgid_rgx){ 
                        foreach ($rcpt in $_.recipients){ 
                            $msgrec[$rcpt] ++ 
                            $bytesrec[$rcpt] += $_.totalbytes 
                            $msgrec_smtpext[$rcpt] ++ 
                            $bytesrec_smtpext[$rcpt] += $_.totalbytes 
                        } 
                    } 
         
                } 
                 
        }
    } 
     
   If ($Include2013HealthMailboxes){  
    if ($_.eventid -eq "RECEIVE" -and $_.source -eq "STOREDRIVER"){ 
        $exch_addrs[$_.sender] ++ 
        $unique_msgsent[$_.sender] ++ 
        $unique_bytessent[$_.sender] += $_.totalbytes 
         
            if ($_.recipients -match $dom_rgx){ 
                $unique_msgsent_exch[$_.sender] ++ 
                $unique_bytessent_exch[$_.sender] += $_.totalbytes 
                } 
 
            if ($_.recipients -notmatch $dom_rgx){ 
                $ext_count = ($_.recipients -notmatch $dom_rgx).count 
                $unique_msgsent_smtpext[$_.sender] ++ 
                $unique_bytessent_smtpext[$_.sender] += $_.totalbytes 
                $total_msgsent[$_.sender] += $ext_count 
                $total_bytessent[$_.sender] += ($ext_count * $_.totalbytes) 
                $total_msgsent_smtpext[$_.sender] += $ext_count 
                $total_bytessent_smtpext[$_.sender] += ($ext_count * $_.totalbytes) 
                } 
                                
             
        }
        }
     Else{
            if ($_.eventid -eq "RECEIVE" -and $_.source -eq "STOREDRIVER" -and $_.Recipients -notmatch "HealthMailbox"){ 
        $exch_addrs[$_.sender] ++ 
        $unique_msgsent[$_.sender] ++ 
        $unique_bytessent[$_.sender] += $_.totalbytes 
         
            if ($_.recipients -match $dom_rgx){ 
                $unique_msgsent_exch[$_.sender] ++ 
                $unique_bytessent_exch[$_.sender] += $_.totalbytes 
                } 
 
            if ($_.recipients -notmatch $dom_rgx){ 
                $ext_count = ($_.recipients -notmatch $dom_rgx).count 
                $unique_msgsent_smtpext[$_.sender] ++ 
                $unique_bytessent_smtpext[$_.sender] += $_.totalbytes 
                $total_msgsent[$_.sender] += $ext_count 
                $total_bytessent[$_.sender] += ($ext_count * $_.totalbytes) 
                $total_msgsent_smtpext[$_.sender] += $ext_count 
                $total_bytessent_smtpext[$_.sender] += ($ext_count * $_.totalbytes) 
                }                                
            }        
        } 
         
    if ($_.eventid -eq "expand"){ 
        $dl[$_.relatedrecipientaddress] ++ 
        } 
    }      
     
} 
 
foreach ($address in $exch_addrs.keys){ 
 
    $stat_rec = (new-object psobject -property (ConvertFrom-StringData (&$obj_table))) 
    $stat_recs += $stat_rec | select $props 
} 
 
$stat_recs | export-csv $outfile -notype

Write-Host "Email stats file is $outfile" -ForegroundColor Green  
 
If ($IncludeDistListStats) { 
        If (Test-Path $dloutfile){ 
            $DL_stats = Import-Csv $dloutfile 
            $dl_list = $dl_stats | Foreach {$_.address} 
            } 
     
        else { 
            $dl_list = @() 
            $DL_stats = @() 
            } 
 
 
        $DL_stats | Foreach { 
            if ($dl[$_.address]){ 
                if ([datetime]$_.lastused -le [datetime]$rundate){  
                    $_.used = [int]$_.used + [int]$dl[$_.address] 
                    $_.lastused = $rundate 
                    } 
                } 
        } 
     
        $dl.keys | Foreach { 
            if ($dl_list -notcontains $_){ 
                $new_rec = "" | select Address,Used,Since,LastUsed 
                $new_rec.address = $_ 
                $new_rec.used = $dl[$_] 
                $new_rec.Since = $rundate 
                $new_rec.lastused = $rundate 
                $dl_stats += @($new_rec) 
            } 
        } 
 
        $dl_stats | Export-Csv $dloutfile -NoTypeInformation 

        Write-Host "DL usage stats file is $dloutfile" -ForegroundColor Green
}