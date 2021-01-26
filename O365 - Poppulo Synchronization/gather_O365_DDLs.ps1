# Modified from http://www.peetersonline.nl/wp-content/get-mygroupmembersrecursive.txt by Hugo Peeters
# Under Creative Commons Attribution 3.0 Netherlands License.

<#
  .SYNOPSIS
    This script gathers user and group objects from exchange.
    From each nested group object, a tag in newsweaver is created.
    All users nested directly within the group are assigned the tag.
  .DESCRIPTION

  .NOTES
    File Name      : gather_objects_from_exchange.ps1
    Author         : Newsweaver
    Prerequisite   : PowerShell V2
    Copyright      : Newsweaver 2015
    Version        : V1.12

    $LastChangedBy: robrien $
	$LastChangedDate: 2017-09-21 10:55:00 +0000 (Thu, 21 Sept 2017)

    $Revision: 54196 $
  .EXAMPLE
    ./gather_objects_from_exchange.ps1
#>

# If the script is called from gather_objects_from_ad.ps1, this parameter will be set to $TRUE. It's $FALSE by default
Param(
    [Parameter(Mandatory=$False,Position=0)]
    [boolean]$calledFromADScript = $true,
    [Parameter(Mandatory=$False)]
	  [HashTable]$groupnames_and_ddls

  )

################ BEGIN - Password Encryption + Decryption ############################

$location = "C:\Users\rxw1401\github\PowerShell\O365 - Poppulo Synchronization\Cred" #"C:\Poppulo Script\gather_objects_from_O365_ddl_capture\Cred"

# ****** Once the password has been read and written to the file created within $location, comment the below line ***********
 Read-Host "Enter O365 Password:" -AsSecureString | ConvertFrom-SecureString | Out-File $location\msol_pw_encrypted.txt

# Choose root location of scripts and go to this location

$location = "C:\Users\rxw1401\github\PowerShell\O365 - Poppulo Synchronization\"
cd $location | out-null

$SecureOffice365Password = Get-Content $location\Cred\msol_pw_encrypted.txt | ConvertTo-SecureString

$username = "robert.wolsky@iff.com"

################ FINISH - Password Encryption + Decryption ############################

################ Open Cloud Session Block Below ############################

$global:Session = $null
$global:CloudSession = $null
$global:SessionName = $null

function createO365Session{
    $cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $username,$SecureOffice365Password


    $global:Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection


    Import-PSSession $global:Session -AllowClobber


    # Connect to Exchange Server to get piace information from mailbox (CustomAttribute1 = EmployeeID)
    $sessionOption = New-PSSessionOption -SkipRevocationCheck
    Get-PSSession|Remove-PSSession


    $global:CloudSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection -SessionOption $sessionOption #-WarningAction SilentlyContinue
    If (!$global:CloudSession){Write-Host "There is no ssesion to cloud, please restart script (check credentials)" -foregroundcolor yellow; break}
    Else {
    Import-PSSession $global:CloudSession
    $global:SessionName = Get-PSSession
    Write-Host "Session Name: $($global:SessionName)"
    }
}

createO365Session
################ Open Cloud Session Block Above ############################

$policy = Get-ExecutionPolicy
#write-host $policy

$config = Import-CliXML nw-config.xml
# account details
$API_user = $config["API_USER"]
$API_user_password = $config["API_PASSWORD"]
$USE_PROXY = $config["USE_PROXY"]
$verboseMode = $config["VERBOSE_MODE"]
$scheduled = $config["SCHEDULED"]
$profile = $config["PROFILE"]
$global:numberOfUsersAccessedMoreThanOnce = 0

$logFolder = ".\Log\$($today.year)$($today.month)$($today.day)"
if((Test-Path $logFolder -PathType container) -eq $False)
{
  New-Item -ItemType directory -Path $logFolder
}

if($verboseMode.ToLower() -eq 'true')
{
    $verboseMode = $true
}
else
{
    $verboseMode = $false
}

if($USE_PROXY.ToLower() -eq 'true')
{
  $USE_PROXY = $true
}
else
{
  $USE_PROXY = $false
}

if($scheduled.ToLower() -eq 'true')
{
  $scheduled -eq $true
}
else
{
  $scheduled = $false
}

if(($API_user_password -eq "") -or ($API_user_password -eq $Null))
{
    $password = Read-Host -assecurestring "Please enter your password"
    $API_user_password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
}

if($profile.ToLower() -eq 'true')
{
  $profile = $true
}
else
{
  $profile = $false
}

$csv_mapping_file = "./generated_ddl_mapping.csv"

$log_file = "$($logFolder)\{0:yyyy-MM-dd_hhmmss}_exchange_execution.log" -f (get-date)
$objectLog = "$($logFolder)\{0:yyyy-MM-dd_hhmmss}_objectRecipientTypes.log" -f (get-date)

#We need to clear the list of errors for this session
$error.Clear()

# Global Variable declaration
$members = @{}
$tagsToBeCreated = New-Object System.Collections.ArrayList
$tagPath = New-Object System.Collections.ArrayList
$accountCodeMapping = @{}

Set-Content $log_file "timestamp;action;object"
$logmsg = $null
Set-Content $objectLog "timestamp;action;object"

# This array will be populated with all email address values from the import data, to compare to the account data for inactivation
$new_emails = New-Object System.Collections.ArrayList

$globalTag = "PoppuloAutomatedExchangeIntegration"
$capture = $tagsToBeCreated.Add($globalTag)

# Newsweaver uses UTF-8 Encoding.
# This function will ensure that any tags used / created will only use the format of:
# Alphanumeric, (inner, not leading/trailing) spaces, hyphens and underscores
function Process-GroupName($group)
{
  $str = $group.trimstart("-/ _,\")
  $str = $str.trimend("-/ _,\")
  $str = $str.trim() -replace '\*','_'
  $str = $str.trim() -replace '[^a-zA-Z0-9\s\\_\\-]',''
  return $str
}

function Process-Group($object)
{
  if($object.Member.Count -ge 1) {
    if(-not $tagPath.Contains("$($object.name)")) {
      if(-not $tagsToBeCreated.Contains("$($object.name)")) {
        $logmsg = "{0:yyyy-MM-dd hh:mm:ss} adding tag to be created. ;" -f (get-date) + $groupName
        Add-Content $log_file "$logmsg"
        $tagsToBeCreated.Add("$($object.name)")
      }

      if($verboseMode -eq 'true')
      {
        $logmsg = "{0:yyyy-MM-dd hh:mm:ss}; group found;" -f (get-date) + $object.name +": "+$object.Member.count
        Add-Content $log_file "$logmsg"
      }

      $tagPath.Add("$($object.name)")
      $group = Get-Group $object -ResultSize Unlimited
      Get-MySubGroupMembersRecursive $group.members $group.name
      $tagPath.Remove("$($object.name)")
    }
  }
  else
  {

    if ($verboseMode -eq 'true')
    {
      $logmsg = "{0:yyyy-MM-dd hh:mm:ss};no objects found;" -f (get-date) + $object.name +": "+ $object.Member.count
      Add-Content $log_file "$logmsg"
    }
  }
}

function Process-User($object, $ParentGroup)
{
# write-host "Third: $($ParentGroup)"

  if($members.ContainsKey("$($object.Guid)"))
  {
    $tags = $members["$($object.Guid)"]["Tags"]
        $tagsAdd = $tagPath + $tags
        $members["$($object.Guid)"]["Tags"] = $tagsAdd
        $global:numberOfUsersAccessedMoreThanOnce++

  } else {

    $user = $null
    #Write-Host "(Process-User) Object RecipientType: $($object.RecipientType)" -ForegroundColor Cyan
    switch($object.RecipientType) {
      PublicFolderMailbox {
        $user = $(try { Get-User "$($object.name)"} catch {$null})
        break
      }
      MailContact {
        $user = $(try { Get-Contact "$($object.name)"} catch {$null})
        break
      }
      Contact {
        $user = $(try { Get-Contact "$($object.name)"} catch {$null})
        break
      }
      UserMailbox {
        $user = $(try { Get-User "$($object.name)"} catch {$null})
        break
      }
      MailUser {
        $user = $(try { Get-User "$($object.name)"} catch {$null})
        break
      }
      User {
        $user = $(try { Get-User "$($object.name)"} catch {$null})
        break
      }
      default {
        break
      }
    }

      $connect = Connect-PSSession -Session $global:CloudSession

      if($user -ne $null)
      {
          #Write-Host "(Process-User) User Found RecipientType: $($user.RecipientType)" -ForegroundColor Cyan
          buildUserDetails $user $ParentGroup
      }
      else
      {
        write-host "$($object) was not found"
        $logmsg = "{0:yyyy-MM-dd hh:mm:ss}; $($object.recipientType) object was null;" -f (get-date) + $Object
        Add-Content $log_file "$logmsg"
      }
    Clear-Variable user -ErrorAction SilentlyContinue

  }
}

function buildUserDetails($userfound, $ParentGroup) {
#  write-host "Parent Group: $($ParentGroup)"
  $tags = @()
  $memberDetails = @{}

  #Personal Details
  $memberDetails.Set_Item("Email",$userfound.UserPrincipalName)
  if($userfound.UserPrincipalName -ne $null){
    [void]$new_emails.Add($userfound.UserPrincipalName)
  }
  #Write-Host "E-Address: $($userfound.UserPrincipalName)" -ForegroundColor Green
  $memberDetails.Set_Item('FirstName',$userfound.firstName)
  $memberDetails.Set_Item('LastName',$userfound.lastName)
  $memberDetails.Set_Item('PreferredName',$userfound.DisplayName)

  #Work Details
  $memberDetails.Set_Item('Company',$userfound.Company)
  $memberDetails.Set_Item('EmployeeNumber',$userfound.EmployeeID)
  $memberDetails.Set_Item('Title',$userfound.Title)
  $memberDetails.Set_Item('JobFunction',$userfound.JobFunction)
  $memberDetails.Set_Item('Team',$userfound.Team)
  $memberDetails.Set_Item('Department',$userfound.Department)
  $memberDetails.Set_Item('Division',$userfound.Division)
  $memberDetails.Set_Item('BusinessUnit',$userfound.BusinessUnit)

  #Work Location
  $memberDetails.Set_Item('Office',$userfound.Office)
  $memberDetails.Set_Item('Site',$userfound.Site)
  $memberDetails.Set_Item('City',$userfound.City)
  $memberDetails.Set_Item('State',$userfound.State)
  $memberDetails.Set_Item('PostCode',$userfound.PostCode)
  $memberDetails.Set_Item('Region',$userfound.Region)
  $memberDetails.Set_Item('Country',$userfound.Country)

  #Tag Path
  # TODO: Check logic when cmdlets run
  #write-host "Checking Group: $($ParentGroup)"

  foreach($dlGroup in $groupnames_and_ddls.Values) {
 # write-host "Nested hash: $($dlGroup.DDL.DisplayName)"

  # if the lookup hashtable $dlGroup contains the DDL name, then use the static group name as a Tag, for the user in the DDL
  # Note: the static group name is stored and paired with the DDL name in the hashtable with the key StaticGroupName
  if($dlGroup.DDL.DisplayName -eq $ParentGroup){
     #write-host "Static: $($dlGroup.StaticGroupName)"
     #write-host "DDL NAME: $($dlGroup.DDL.DisplayName)"
     #$capture = $tagsToBeCreated.Add($dlGroup.StaticGroupName)
     if($tagPath -notcontains $dlGroup.StaticGroupName){
        $capture = $tagPath.Add($dlGroup.StaticGroupName)
      }
    }
  }
  if($tagPath -notcontains $globalTag){
     $capture = $tagPath.Add("$($globalTag)")
  }
  $tags += $tagPath

  $memberDetails.Set_Item("Tags", $tags)

  #User Identifier
  $objectId = $userfound.GUID

  if($objectId -eq $NULL)
  {
    $logmsg = "{0:yyyy-MM-dd hh:mm:ss}; object with no id found;" -f (get-date) + $userfound
      Add-Content $log_file "$logmsg"
  } else
  {
    $members.Set_Item($objectId,$memberDetails)
  }



  if($profile)
  {
    $global:activeObjects++
  }

}

function Get-MySubGroupMembersRecursive
{
  param($Objects,$ParentGroup)
 # Write-Host "Second: $($ParentGroup)"
  ForEach ($Object in $Objects)
  {
   # Write-Host "(Get-MySubGroupMembersRecursive) Object RecipientType: $($Object.RecipientType)" -ForegroundColor Magenta
    switch($Object.RecipientType)
    {
      MailContact {
        Process-User $Object $ParentGroup
        break
      }
      Contact {
        Process-User $Object $ParentGroup
        break
      }
      UserMailbox {
     #  Write-Host "Passing to User (userMailbox): $($ParentGroup)"
        Process-User $Object $ParentGroup
        break
      }
      MailUser {
     # Write-Host "Passing to User (MailUser): $($ParentGroup)"
        Process-User $Object $ParentGroup
        break
      }
      User {
    #   Write-Host "Passing to User (User): $($ParentGroup)"
        Process-User $object $ParentGroup
        break
      }
      MailUniversalDistributionGroup {
        Process-Group($object)
        break
      }
      MailNonUniversalGroup {
        Process-Group($object)
        break
      }
      default {
        if($profile) {
          $global:unusableObjects++
        }

              if ($verboseMode) {
                  $logmsg = "{0:yyyy-MM-dd hh:mm:ss}; object of unknown type found;" -f (get-date) + $object
                  Add-Content $log_file "$logmsg"

              }
        $logmsg = "{0:yyyy-MM-dd hh:mm:ss}; object of unknown type found;" -f (get-date) + $object
              Add-Content $objectLog "$logmsg"

              break
        }
    }
  }
}

##################

# Process collected group names captured in AD script
foreach($dlGroup in $groupnames_and_ddls.Values) {
    $dlGroup.DDL.DisplayName
    $dlGroup.StaticGroupName
    $dlGroup.Account

    #ProccessDynamicGroup $dlGroup.StaticGroupName  $dlGroup.Account
}

##################

try
{
    Import-Csv -Path $csv_mapping_file -Delimiter ';' |`
        ForEach-Object {

        $currentSession = Get-PSSession

        Write-Host "Checking Session Name: $($currentSession) - for a match on the previous session."

        if($currentSession -ne $global:SessionName){
           Write-Host "Opening New Cloud Session!" -ForegroundColor Magenta
           createO365Session
        }
        else{
            Write-Host "O365 Session already in progress: $($currentSession)" -ForegroundColor Green
        }

        $ParentGroupName = "$($_.dynamic_dl)".Trim()
        $Accounts = "$($_.nw_account_code)".Trim()

        Write-Host "DYNAMIC DL: $($ParentGroupName)"
        Write-Host "Account: $($Accounts)"

        $ParentGroup = Get-DynamicDistributionGroup "$($ParentGroupName)" | select name,displayname,recipientfilter,recipientcontainer

        write-host ""
        write-host "Name: $($ParentGroup.name)"
        write-host "Filter: $($ParentGroup.RecipientFilter)"
        write-host "OU: $($ParentGroup.RecipientContainer)"

        If ($ParentGroup -eq $null)
        {
            Write-Warning "Group ($ParentGroupName) not found."
            $logmsg = "{0:yyyy-MM-dd hh:mm:ss};group not found;" -f (get-date) + $ParentGroupName
            Add-Content $log_file "$logmsg"
            break
        }
        Else
        {

        $ddgm = Get-Recipient -RecipientPreviewFilter $ParentGroup.RecipientFilter -OrganizationalUnit $ParentGroup.RecipientContainer -ResultSize Unlimited
        write-host "DDL Membership:" $ddgm
        Write-Host "DDL Membership Count: $($ddgm.Count)"
        if($profile)
        {
            $logmsg = "{0:yyyy-MM-dd hh:mm:ss};MSOL search result;" -f (get-date) + $ParentGroup
            Add-Content $log_file "$logmsg"

            $msrmsg = "Execution Start Time: {0:yyyy-MM-dd hh:mm:ss}" -f (get-date)
            Add-Content $measurement_file "$msrmsg"
        }

        $logmsg = "{0:yyyy-MM-dd hh:mm:ss};AD search result;" -f (get-date) + $ParentGroup
        Add-Content $log_file "$logmsg"

        $groupNameTag = Process-GroupName "$($ParentGroup.name)"
       # write-host "FIRST PArent Group: $($groupNameTag)"
        $capture = $tagsToBeCreated.Add("$($groupNameTag)")
        $capture = $tagPath.Add("$($groupNameTag)")
         #$capture = $tagsToBeCreated.Add("$($ParentGroupName)")
        # $capture = $tagPath.Add("$($ParentGroupName)")

        Get-MySubGroupMembersRecursive $ddgm $groupNameTag

        $capture = $tagPath.Remove("$($groupNameTag)")
      }
    }
        if($profile)
        {
            $msrmsg = "Execution Finish Time: {0:yyyy-MM-dd hh:mm:ss}" -f (get-date)
            Add-Content $measurement_file "$msrmsg"
            $msrmsg = "Total Objects: $($global:totalObjects)"
            Add-Content $measurement_file "$msrmsg"
            $msrmsg = "Active Objects: $($global:activeObjects)"
            Add-Content $measurement_file "$msrmsg"
            $msrmsg = "Inactive Objects: $($global:inactiveObjects)"
            Add-Content $measurement_file "$msrmsg"
            $msrmsg = "Unusable Objects: $($global:unusableObjects)"
            Add-Content $measurement_file "$msrmsg"
            $msrmsg = "Total Users: $($members.Count)"
            Add-Content $measurement_file "$msrmsg"
        }

        $account = ""

        if($Accounts) {
        $Accounts.Split(",") | Foreach {
        $account = "$($_)".Trim()
        if($members.count -gt 0)
        {
               echo "Distribution List: $($ParentGroupName) <-> Account: $($account)"
               $logmsg = "{0:yyyy-MM-dd hh:mm:ss};API upload;" -f (get-date) + $ParentGroupName +"<->"+ $account
               Add-Content $log_file "$logmsg"

               #.\inactivate_subs.ps1 -new_emails $new_emails -account_code $account -user $API_user -password $API_user_password -permission 'All' -useProxy $USE_PROXY -globalTag $globalTag

               $members | .\nw_sync_employees.ps1 -account_code $account -user $API_user -password $API_user_password -permission 'All' -tagsToBeCreated $tagsToBeCreated -useProxy $USE_PROXY

               #$members.keys | foreach { $members.Item($_).values | out-file -Append -FilePath ".\testOutput.txt" } # TODO - remove in production
            }
            else
            {
               echo "Sorry no can do: List $($ParentGroupName) does not contain any users to upload!"
               $logmsg = "{0:yyyy-MM-dd hh:mm:ss};API Upload skipped, no users found;" -f (get-date) + $ParentGroupName
               Add-Content $log_file "$logmsg"
            }

          }
        }
        else
        {
        echo "Sorry no can do: The account code that should be mapped with this list $($ParentGroupName) does not exist in the mapping file.."
        $logmsg = "{0:yyyy-MM-dd hh:mm:ss};API Upload failed, account code missing;" -f (get-date) + $ParentGroupName
        Add-Content $log_file "$logmsg"
        }

        if($profile)
        {
          $global:totalObjects = 0
          $global:activeObjects = 0
          $global:unusableObjects = 0
          $global:inactiveObjects = 0
        }

        $tagsToBeCreated.Clear()
        $tagPath.Clear()
        $members.Clear()

    if($profile)
    {
    write-host ""
    Write-Host "Users accessed more than once: $($global:numberOfUsersAccessedMoreThanOnce)"
    }

    if($scheduled -eq 'true')
    {
    Stop-Process -Id $PID
    }
}
catch
{
    write-host "Caught an exception:" -ForegroundColor Red
    write-host "Exception Name: $($_.Exception.ItemName)" -ForegroundColor Red
    write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
    write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red

    $logmsg = "{0:yyyy-MM-dd hh:mm:ss};Exception found!;" -f (get-date) + $_.Exception.GetType().FullName + " ; " + $_.Exception.Message + " ; Item: " + $_.Exception.ItemName
    Add-Content $log_file "$logmsg"
    continue;
}
finally
{
    if($new_emails -ne $null){
      Import-Csv -Path $csv_mapping_file -Delimiter ';' |`
        ForEach-Object {
           $Accounts = "$($_.nw_account_code)".Trim()
            if($Accounts){
                $Accounts.Split(",") | Foreach {
                  $account = "$($_)".Trim()
                    .\inactivate_subs.ps1 -new_emails $new_emails -account_code $account -user $API_user -password $API_user_password -permission 'All' -useProxy $USE_PROXY -globalTag $globalTag
            }
            break
        }
      }
    }
    #Remove PSSession to Exchange server
    Remove-PSSession $global:CloudSession

    $logmsg = "{0:yyyy-MM-dd hh:mm:ss};Script finished!;" -f (get-date)
    Add-Content $log_file "$logmsg"

    Remove-PSSession $global:Session

    if($error.Count -gt 0)
    {
    $error_log = "$($logFolder)\{0:yyyy-MM-dd_hhmmss}_errorList.log" -f (get-date)
    Set-Content $error_log "******************* Errors *******************"
    foreach($e in $error)
    {
        Add-Content $error_log "`n ------------------------------------------- `n"
        Add-Content $error_log ($e | Format-Table | Out-String)
    }
    }
}