

#Populate Identity Array
[Array] $v = get-content 'c:\temp\voiceusers.txt'

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($vuser in [Array] $v)
{
$valid = ""
#Check for valid recipient
trap { 'User: '+$vuser+' is not a valid recipient'; continue }
$valid = get-exorecipient -Identity $vuser -ErrorAction Stop
$out = $valid | Select DisplayName, RecipientType, PrimarySMTPAddress

    $objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Display -Value $out.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name Type -Value $out.RecipientType

    $objEX | Add-Member -MemberType NoteProperty -Name validDisplay -Value $out.PrimarySMTPAddress

    $arrResults += $objEX 
    
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\vuserWITHvalid_RESULT.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Find Mailboxes with Send-As permissions]
#-----------------------------------------------------------------------------
#>