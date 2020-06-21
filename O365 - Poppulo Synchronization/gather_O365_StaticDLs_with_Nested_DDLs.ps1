 # Modified from http://www.peetersonline.nl/wp-content/get-mygroupmembersrecursive.txt by Hugo Peeters
# Under Creative Commons Attribution 3.0 Netherlands License.


<#
  .SYNOPSIS
    This script gathers user and group objects from active directory.
    From each nested group object, a tag in newsweaver is created.
    All users nested directly within the group are assigned the tag.
  .DESCRIPTION


  .NOTES
    File Name      : gather_objects_from_ad_ddl_capture.ps1
    Author         : Newsweaver
    Prerequisite   : PowerShell V2
    Copyright      : Newsweaver 2015
    Version        : V1.11


    $LastChangedBy: robrien $
    $LastChangedDate: 2017-12-14 11:15:00 +0000 (Thur, 14 Dec 2017)


    $Revision: 54111 $
  .EXAMPLE
    ./gather_objects_from_ad_ddl_capture.ps1
#>


################ BEGIN - Password Encryption + Decryption ############################

$location = $PSScriptRoot

# ****** Once the password has been read and written to the file created within $location, comment the below line ***********
if((Test-Path $loaction\Cred\msol_pw_encrypted.txt) -eq $false){ 
Read-Host "Enter O365 Password:" -AsSecureString | ConvertFrom-SecureString | Out-File $location\Cred\msol_pw_encrypted.txt
}
# Choose root location of scripts and go to this location

set-location $location | out-null

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
    Write-Host "Session Name: $($global:SessionName)" -ForegroundColor Green
    }
}

createO365Session
################ Open Cloud Session Block Above ############################


$config = Import-CliXML nw-config.xml


# account details
$API_user = $config["API_USER"]
$API_user_password = $config["API_PASSWORD"]
$USE_PROXY = $config["USE_PROXY"]
$verboseMode = $config["VERBOSE_MODE"]
$scheduled = $config["SCHEDULED"]

$profile = $config["PROFILE"]
$global:numberOfUsersAccessedMoreThanOnce = 0
$today=Get-Date
$logFolder = "Log\$($today.year)$($today.month)$($today.day)"
if((Test-Path $logFolder -PathType container) -eq $False)
{
  New-Item -ItemType directory -Path $logFolder
}


if($verboseMode.toLower() -eq 'true')
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


# use this as GC:
$ADserver = $config["AD_SERVER"]
# import file (full path or "./" if in same folder as script)
$csv_mapping_file = "./nw_master_dl_mapping.csv"
$log_file = "$($logFolder)\{0:yyyy-MM-dd_hhmmss}_gather_objects_execution.log" -f (get-date)


# This array will be populated with all email address values from the import data, to compare to the account data for inactivation
$new_emails = New-Object System.Collections.ArrayList


#We need to clear the list of errors for this session
$error.Clear()


# Any Dynamic Distribution Groups are written to generated_ddl_mapping.csv
# They are then processed by gather_objects_from_exchange.ps1
$dynamicDLFile = "generated_ddl_mapping.csv"
$dynamicDLFileHeaders = "dynamic_dl;nw_account_code"


Set-Content $dynamicDLFile $dynamicDLFileHeaders


# Global Variable declaration
$groupnames_and_ddls = @{}
$members = @{}
$tagsToBeCreated = New-Object System.Collections.ArrayList
$tagPath = New-Object System.Collections.ArrayList
$accountCodeMapping = @{}
$dynamicDLs = New-Object System.Collections.ArrayList
$global:foundDynamicDL = $FALSE


Set-Content $log_file "timestamp;action;object"
$logmsg = $null

$globalTag = "PoppuloAutomatedADIntegration"
$capture = $tagsToBeCreated.Add($globalTag)


# Get list of disabled user accounts
$du = @()
Get-User -RecipientTypeDetails DisabledUser -ResultSize unlimited | % {[array]$du += @($_.GUID)}
write-host "DU LIST: "$du


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


function collectDynamicDistributionGroup($DynamicDistributionGroup)
{
  if($verboseMode)
  {
    $message = "Dynamic Distribution List Found: $($DynamicDistributionGroup.DisplayName)"
    $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
    Add-Content $log_file "$logMessage"
  }


  # Add the DynamicDL's object name to the Collection
  if($DynamicDistributionGroup.DisplayName -ne $null){
    $capture = $dynamicDLs.Add("$($DynamicDistributionGroup.DisplayName)")
    # Set the found flag to $TRUE
    $global:foundDynamicDL = $TRUE
  }
}


function Get-MySubGroupMembersRecursive
{
  param($DNs,$ParentGroup)


  $parentName = Process-GroupName("$($ParentGroup)")
  Write-Host "Looping Members of Group: $($parentName)" -ForegroundColor Cyan
  # For each group member (membership list of a group from the Parent group in a mapping file)
  ForEach ($DN in $DNs)
  {
  #write-host "TYPE:: "$DN.RecipientType
    if($verboseMode -eq 'true')
    {
      $message = "processing object: $($DN)"
      $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
      Add-Content $log_file "$logMessage"
    }
    if($profile)
      {
        $global:totalObjects++
      }


    if($DN -eq $null)
    {
      if($profile)
      {
        $global:inactiveObjects++
      }


      $message = "object not found: $($DN)"
      $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
      Add-Content $log_file "$logMessage"
    }
    else
    {


      If ($DN.RecipientType -eq 'MailUniversalDistributionGroup' -or $DN.RecipientType -eq 'MailUniversalSecurityGroup' -or $DN.RecipientType -eq 'MailNonUniversalGroup')
      {
      Write-Host "Searching Nested Group: $($DN.DisplayName)"


        if($verboseMode -eq 'true')
        {
          $message = "group $($DN.DisplayName) found"
          $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
          Add-Content $log_file "$logMessage"
        }


        $groupName = Process-GroupName("$($DN.DisplayName)")


        $message = "processing group: $($groupName)"
        $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
        Add-Content $log_file "$logMessage"


        # take the nested group of the top level, and get all all nested memebers
        # $Object is a nested group within a top level group of the parent
        $Object = $(try {Get-DistributionGroupMember -Identity $DN.name -ResultSize unlimited} catch {$null})
        write-host "$($DN.DisplayName) - $($DN.RecipientType) - Object: $($Object.RecipientType) - Count: $($Object.Member.Count)"


        #If ($Object.Member.Count -ge 1)
        If ($Object -ne $null)
        {
          #Recursive nested group prevention
          if ( -not $tagPath.Contains($groupName))
          {
            if ( -not $tagsToBeCreated.Contains($groupName))
            {
              $message = "adding tag to be created: $($groupName)"
              $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
              Add-Content $log_file "$logMessage"


              $capture = $tagsToBeCreated.Add("$($groupName)")
            }


            if($profile)
            {
              $global:activeObjects++
            }


            $capture = $tagPath.Add("$($groupName)")
            Write-Host "member found: $($Object)"
            if($Object -ne $null -and $Object.Member -eq $null) {

              Get-MySubGroupMembersRecursive $Object $groupName
              $capture = $tagPath.Remove("$($groupName)")

            }
            else{

              Get-MySubGroupMembersRecursive $Object.Member $groupName

              $capture = $tagPath.Remove("$($groupName)")
            }
          }
          else
          {
            $message = "recursive dl nesting detected: $($groupName)"
            $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
            Add-Content $log_file "$logMessage"
          }


        }
        else
        {
          $message = "no objects found in group: $($groupName)"
          $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
          Add-Content $log_file "$logMessage"
        }
      }


      elseif ($DN.RecipientType -eq "UserMailbox" -or $DN.RecipientType -eq "User" -or $DN.RecipientType -eq "MailUser")
      {


        if($members.ContainsKey($DN.GUID))
        {
          $tags = $members[$DN.GUID]["Tags"]
          $tagsAdd = $tagPath + $tags
          $members[$DN.GUID]["Tags"] = $tagsAdd
          $global:numberOfUsersAccessedMoreThanOnce++


        }
        else
        {
          #$userfound = $(try {Get-MsolUser -ObjectId $DN.ObjectId} catch{$null})
          $userfound = $(try {Get-User -Identity $DN.DisplayName} catch{$null})


          #Write-Host "USER: $($userfound.UserPrincipalName)"


          if($userfound -eq $null)
          {
            if($profile)
            {
              $global:inactiveObjects++
            }


            $message = "user not found: $($DN.DisplayName)"
            $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
            Add-Content $log_file "$logMessage"
          }
          else {


            #Importing inactive users is bad..
            if($du -notcontains $userfound.GUID)
            {
              if($verboseMode)
              {
                $message = "processing active user: $($userfound.mail)"
                $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
                Add-Content $log_file "$logMessage"
              }


              $connect = Connect-PSSession -Session $global:CloudSession


              buildUserDetails($userfound)


              if($profile)
              {
                $global:activeObjects++
              }
            }
            else
            {
              if($profile)
              {
                $global:inactiveObjects++
              }
              if($verboseMode)
              {
                $message = "inactive user found: $($userfound.UserPrincipalName)"
                $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
                Add-Content $log_file "$logMessage"
              }
            }
          }
          Clear-Variable userfound
        }
      }
      elseif ($DN.RecipientType -eq 'DynamicDistributionGroup')
      {
        $groupnames_and_ddls_capture = @{}
        $groupnames_and_ddls_capture.Set_Item("StaticGroupName",$parentName)
        $groupnames_and_ddls_capture.Set_Item("DDL",$Object)
        $groupnames_and_ddls_capture.Set_Item("Account", $Account);


        $groupnames_and_ddls.Set_Item("$parentName",$groupnames_and_ddls_capture)
        Write-Host "******** GROUP HASH ********" $groupnames_and_ddls
        collectDynamicDistributionGroup($Object)
      }
      else
      {
        if($profile)
        {
          $global:unusableObjects++
        }


        $message = "object of unknown type found: $($DN.DisplayName)"
        $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
        Add-Content $log_file "$logMessage"
      }
    }
  }
}


function buildUserDetails($userfound) {


  $tags = @()
  $memberDetails = @{}


  #Personal Details
  $memberDetails.Set_Item("Email",$userfound.UserPrincipalName)
  if($userfound.UserPrincipalName -ne $null){
    [void]$new_emails.Add($userfound.UserPrincipalName)
  }
  $memberDetails.Set_Item('FirstName',$userfound.FirstName)
  $memberDetails.Set_Item('LastName',$userfound.LastName)
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
  $memberDetails.Set_Item('City',$userfound.l)
  $memberDetails.Set_Item('State',$userfound.State)
  $memberDetails.Set_Item('PostCode',$userfound.PostCode)
  $memberDetails.Set_Item('Region',$userfound.Region)
  $memberDetails.Set_Item('Country',$userfound.Country)


  #Tag Path
  if($tagPath -notcontains $globalTag){
    $capture = $tagPath.Add("$($globalTag)")
  }
  $tags += $tagPath
  $memberDetails.Set_Item("Tags", $tags)


  #User Identifier
  $members.Set_Item($userfound.GUID,$memberDetails)
  #write-host "Members:" $members
}


try
{


  Import-Csv -Path $csv_mapping_file -Delimiter ';' |`
    ForEach-Object {


     $ParentGroupName = "$($_.master_dl)".Trim()
     $Accounts = "$($_.nw_account_code)".Trim()

     $ParentGroup = Get-DistributionGroup -Identity $ParentGroupName -ResultSize unlimited

      If ($ParentGroup -eq $null)
      {
        Write-Warning "Group ($ParentGroup) not found."
        $message = "group not found: $($ParentGroup)"
        $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
        Add-Content $log_file "$logMessage"
      }
      Else
      {
        $firstmembers = Get-DistributionGroupMember -Identity $ParentGroup.name -ResultSize unlimited


        if($profile)
        {
          $logmsg = "{0:yyyy-MM-dd hh:mm:ss};AD search result;" -f (get-date) + $ParentGroup
          Add-Content $log_file "$logmsg"


          $msrmsg = "Execution Start Time: {0:yyyy-MM-dd hh:mm:ss}" -f (get-date)
          Add-Content $measurement_file "$msrmsg"
        }


        $message = "MSOL Search Result: $($ParentGroup.DisplayName)"
        $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
        Add-Content $log_file "$logMessage"


        ForEach ($member in $firstmembers)
        {
          #write-host "Type ($member): "$member.RecipientType
          $currentSession = Get-PSSession
          if($currentSession -ne $global:SessionName){
            Write-Host "Opening New Cloud Session!" -ForegroundColor Magenta
            createO365Session
          }
          else{
            Write-Host "O365 Session already in progress." -ForegroundColor Green
          }

          if(($member -ne $null) -and ($member.RecipientType -eq 'MailUniversalDistributionGroup'-or $member.RecipientType -eq 'MailUniversalSecurityGroup' -or $member.RecipientType -eq 'MailNonUniversalGroup'))
          # if(($member -ne $null) -and ($member.RecipientType -ne 'DynamicDistributionGroup'))
          {
            $groupNameTag = Process-GroupName("$($member.DisplayName)")


            $capture = $tagsToBeCreated.Add($groupNameTag)
            $capture = $tagPath.Add("$($groupNameTag)")

            Write-Host "Searching Group: $($member.DisplayName)" -ForegroundColor Green

            Get-MySubGroupMembersRecursive ( Get-DistributionGroupMember -Identity $member.name -ResultSize unlimited) $groupNameTag


            $capture = $tagPath.Remove("$($groupNameTag)")


          }
         elseif(($member -ne $null) -and ($member.RecipientType -eq 'DynamicDistributionGroup'))
          {


            $groupnames_and_ddls_capture = @{}
            $groupnames_and_ddls_capture.Set_Item("StaticGroupName",$ParentGroup)
            $groupnames_and_ddls_capture.Set_Item("DDL",$member)
            $groupnames_and_ddls_capture.Set_Item("Account", $Account);


            $groupnames_and_ddls.Set_Item("$ParentGroup",$groupnames_and_ddls_capture)
            Write-Host "******** GROUP HASH ********" $groupnames_and_ddls
            collectDynamicDistributionGroup($member)
          }
          elseif(($member -ne $null) -and ($member.RecipientType -eq 'UserMailBox' -or $member.RecipientType -eq 'MailUser'))
          {


          Write-Host "******** Nested User Found in Top Level Group ********"


          #$userfound = $(try {Get-MsolUser -ObjectId $DN.ObjectId} catch{$null})
          $userfound = $(try {Get-User -Identity $member.DisplayName} catch{$null})


          #Write-Host "GROUP: $($DN.DisplayName) - USER: $($userfound.UserPrincipalName)"


          if($userfound -eq $null)
          {
            if($profile)
            {
              $global:inactiveObjects++
            }


            $message = "user not found: $($member.DisplayName)"
            $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
            Add-Content $log_file "$logMessage"
          }
          else {


            #Importing inactive users is bad..
            if($du -notcontains $userfound.GUID)
            {
              if($verboseMode)
              {
                $message = "processing active user: $($userfound.mail)"
                $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
                Add-Content $log_file "$logMessage"
              }


              $connect = Connect-PSSession -Session $global:CloudSession


              $capture = $tagPath.Add("$($ParentGroup)")


              buildUserDetails($userfound)


              $capture = $tagPath.Remove("$($ParentGroup)")


              if($profile)
              {
                $global:activeObjects++
              }
            }
            else
            {
              if($profile)
              {
                $global:inactiveObjects++
              }
              if($verboseMode)
              {
                $message = "inactive user found: $($userfound.UserPrincipalName)"
                $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
                Add-Content $log_file "$logMessage"
              }
            }
          }
          Clear-Variable userfound
        }
          else
          {
            echo "Parent direct member group was null - Parent: $($ParentGroup) | Member: $($member)"


            $message = "This object directly underneath the Master Dl $($ParentGroup) is not a group"
            $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
            Add-Content $log_file "$logMessage"
          }
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
         if($Accounts)
         {
          if($Accounts)
          {


            # Any Dynamic Distribution Group found under the current ParentGroup are mapped with the same account(s) as the ParentGroup
            ForEach ($ddl in $dynamicDLs)
            {
              Add-Content $dynamicDLFile "$($ddl);$($Accounts)"
            }


            $Accounts.Split(",") | Foreach {
              $account = "$($_)".Trim()
              if($members.count -gt 0)
              {


                echo "Importing Data To Account: $($account)"


                $message = "Api upload for $($account)"
                $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
                Add-Content $log_file "$logMessage"


                #.\inactivate_subs.ps1 -new_emails $new_emails -account_code $account -user $API_user -password $API_user_password -permission 'All' -useProxy $USE_PROXY -globalTag $globalTag


                #Write-Host "Subscribers Inactivated. Importing new data now."


                $members | .\nw_sync_employees.ps1 -account_code $account -user $API_user -password $API_user_password -permission 'All' -tagsToBeCreated $tagsToBeCreated -useProxy $USE_PROXY
                #$members.keys | foreach { $members.Item($_).values | out-file -Append -FilePath ".\testOutput.txt" } # TODO - remove in production
                #$groupnames_and_ddls | foreach { $groupnames_and_ddls.Item($_).values | out-file -Append -FilePath ".\groupsanddls.txt" } # TODO - remove in production
              }
              else
              {
                echo "Sorry: No users to upload!"


                $message = "Api upload skipped for $($account), no users found"
                $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
                Add-Content $log_file "$logMessage"
              }


            }
          }
          else
          {
            echo "Sorry no can do: No account codes found"


            $message = "Api upload failed, account code missing"
            $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
            Add-Content $log_file "$logMessage"
          }
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
    $dynamicDLs.Clear()
  }


  if($scheduled -eq 'true')
  {
    Stop-Process -Id $PID
  }
}
catch
{
  write-host "Caught an exception:" -ForegroundColor Red
  write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
  write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red


  $message = "Exception found!: Name: $($_.Exception.GetType().FullName) Message: $($_.Exception.Message)"
  $logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
  Add-Content $log_file "$logMessage"
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
                   #   .\inactivate_subs.ps1 -new_emails $new_emails -account_code $account -user $API_user -password $API_user_password -permission 'All' -useProxy $USE_PROXY -globalTag $globalTag
            }
            break
        }
      }
    }

  Write-Host "####################### FINISHED DL Imports #######################"

  if($global:foundDynamicDL)
  {
    Write-Host "####################### ENTERING DDL PROGRAM #######################"


    # Call exchange script to process any DynamicDistributionGroups, using the mappings written to generated_ddl_mapping.csv
    .\gather_objects_from_exchange.ps1 -calledFromADScript $TRUE -groupnames_and_ddls $groupnames_and_ddls


    Write-Host "####################### FINISHED DDL PROGRAM #######################"
  }


  #Remove PSSession to Exchange server
  Remove-PSSession $global:CloudSession


  Remove-PSSession $global:Session


  $logmsg = "{0:yyyy-MM-dd hh:mm:ss};Script finished!;" -f (get-date)
  Add-Content $log_file "$logmsg"


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
