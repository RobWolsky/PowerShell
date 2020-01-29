
# Modified from http://www.peetersonline.nl/wp-content/get-mygroupmembersrecursive.txt by Hugo Peeters
# Under Creative Commons Attribution 3.0 Netherlands License.

<#
	.SYNOPSIS  
		This script gathers user and group objects from active directory. 
		From each nested group object, a tag in newsweaver is created.
		All users nested directly within the group are assigned the tag.
	.DESCRIPTION
		
	.NOTES	
		File Name      : gather_objects_from_ad.ps1  
		Author         : Poppulo
		Prerequisite   : PowerShell V2
		Copyright      : Poppulo 2015
		Version        : V1.11
		
		$LastChangedBy: josullivan $
		$LastChangedDate: 2015-02-03 17:20:40 +0000 (Tue, 03 Feb 2015) $
		$Revision: 54111 $
	.EXAMPLE
		./gather_objects_from_ad.ps1
#>

Import-Module ActiveDirectory
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

# Global Variable declaration
$members = @{}
$tagsToBeCreated = New-Object System.Collections.ArrayList
$tagPath = New-Object System.Collections.ArrayList
$accountCodeMapping = @{}

Set-Content $log_file "timestamp;action;object"
$logmsg = $null

# Poppulo uses UTF-8 Encoding.
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

function Get-MySubGroupMembersRecursive
{
	param($DNs,$ParentGroup)
	ForEach ($DN in $DNs)
	{
		if($verboseMode -eq 'true')
		{
			$message = "processing object: $($DN)"
			$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
			Add-Content $log_file "$logMessage"		
		}
			
		$Object = $(try {Get-ADObject $DN -Properties member, name, displayname  -server $ADServer } catch{$null})
		if($profile)
    	{
    		$global:totalObjects++	
    	}
	
		if($Object -eq $null)
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
		
			If ($Object.ObjectClass -eq 'group')
			{
				if($verboseMode -eq 'true')
				{
					$message = "group $($object.name) found"
					$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
					Add-Content $log_file "$logMessage"
				}

				$groupName = Process-GroupName("$($object.name)")
				
				$message = "processing group: $($groupName)"
				$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
				Add-Content $log_file "$logMessage"
				
				If ($Object.Member.Count -ge 1)
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
						Get-MySubGroupMembersRecursive $Object.Member $groupName
						$capture = $tagPath.Remove("$($groupName)")
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
			
			elseif ($Object.ObjectClass -eq 'user')
			{	

				if($members.ContainsKey($object.ObjectGUID))
				{
					$tags = $members[$object.ObjectGUID]["Tags"]
					$tagsAdd = $tagPath + $tags
					$members[$object.ObjectGUID]["Tags"] = $tagsAdd
					$global:numberOfUsersAccessedMoreThanOnce++

				}
				else
				{
					
					$userfound = $(try {Get-ADUser $DN -Properties * -server $ADServer } catch{$null})
					
					if($userfound -eq $null)
					{
						if($profile)
						{
							$global:inactiveObjects++	
						}
						
						$message = "user not found: $($object.name)"
						$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
						Add-Content $log_file "$logMessage"
					}
					else {
					
						#Importing inactive users is bad..
						if($userfound.enabled)
						{
							if($verboseMode)
							{
								$message = "processing active user: $($userfound.mail)"
								$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
								Add-Content $log_file "$logMessage"
							}
							
							buildUserDetails($userfound)
							
							if($profile)
							{
								$global:activeObjects++	
							}
						}
						else
						{
							<#if($profile)
							{
								$global:inactiveObjects++	
							}#>
							if($verboseMode)
							{
								$message = "inactive user found: $($userfound.mail)"
								$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
								Add-Content $log_file "$logMessage"
							}
						}
					}
					Clear-Variable userfound 
				}
			}
			else
			{
				if($profile)
				{
					$global:unusableObjects++	
				}
				
				$message = "object of unknown type found: $($object.name)"
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
	$memberDetails.Set_Item("Email",$userfound.Mail)
if($userfound.Mail -ne $null){
        [void]$new_emails.Add($userfound.Mail)
    }
	$memberDetails.Set_Item('FirstName',$userfound.givenName)
	$memberDetails.Set_Item('LastName',$userfound.surName)
	$memberDetails.Set_Item('PreferredName',$userfound.DisplayName)
	
	#Work Details
	$memberDetails.Set_Item('Company',$userfound.Company)
	$memberDetails.Set_Item('EmployeeNumber',$userfound.employeeID)
	$memberDetails.Set_Item('Title',$userfound.title)
	$memberDetails.Set_Item('JobFunction',$userfound.JobFunction)
	$memberDetails.Set_Item('Team',$userfound.Team)
	$memberDetails.Set_Item('Department',$userfound.department)
	$memberDetails.Set_Item('Division',$userfound.businessCategory)
	$memberDetails.Set_Item('BusinessUnit',$userfound.BusinessUnit)
	
	#Work Location
	$memberDetails.Set_Item('OfficeBuilding',$userfound.physicalDeliveryOfficeName)
	$memberDetails.Set_Item('Site',$userfound.Site)
	$memberDetails.Set_Item('City',$userfound.l)
	#$memberDetails.Set_Item('State',$userfound.State)
	$memberDetails.Set_Item('PostCode',$userfound.postalCode)
	$memberDetails.Set_Item('StateRegion',$userfound.st)
	$memberDetails.Set_Item('CountryName',$userfound.co)
	$memberDetails.set_item('CountryCode',$userfound.countryCode)

	#Tag Path
	$tags += $tagPath
	$memberDetails.Set_Item("Tags", $tags)
	
	#User Identifier
	$members.Set_Item($userfound.ObjectGUID,$memberDetails)
	
}

try
{

	Import-Csv -Path $csv_mapping_file -Delimiter ';' |`
	    ForEach-Object {
			$ParentGroupName = "$($_.master_dl)".Trim()
			$Accounts = "$($_.nw_account_code)".Trim()
	
       $globalTag =  $ParentGroupName
            $capture = $tagsToBeCreated.Add($globalTag)

			$ParentGroup = $(try {Get-ADGroup -ldapfilter "(name=$($ParentGroupName))" -Properties members,displayname  -server $ADServer } catch {$null})
	
			If ($ParentGroup -eq $null)
			{
				Write-Warning "Group ($ParentGroupName) not found."
				$message = "group not found: $($ParentGroupName)"
				$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
				Add-Content $log_file "$logMessage"
			}
			Else
			{
				$FirstMembers = $ParentGroup.Members
				if($profile)
				{
					$logmsg = "{0:yyyy-MM-dd hh:mm:ss};AD search result;" -f (get-date) + $ParentGroup
					Add-Content $log_file "$logmsg"
					
					$msrmsg = "Execution Start Time: {0:yyyy-MM-dd hh:mm:ss}" -f (get-date)
					Add-Content $measurement_file "$msrmsg"
				}
		
				$message = "AD Search Result: $($ParentGroup)"
				$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
				Add-Content $log_file "$logMessage"
				
				ForEach ($member in $firstmembers) 
				{
					$object = $(try {Get-ADObject $member -Properties member, name, displayname -server $ADServer } catch{$null})
					if(($object -ne $null) -and ($object.ObjectClass -eq 'group'))
					{
$capture = $tagPath.Add("$($ParentGroupName)")
						$groupNameTag = Process-GroupName("$($object.name)")
						$capture = $tagsToBeCreated.Add($groupNameTag)
						$capture = $tagPath.Add("$($groupNameTag)")
						
						Get-MySubGroupMembersRecursive $object.Member $groupNameTag
						$capture = $tagPath.Remove("$($groupNameTag)")
$capture = $tagPath.Remove("$($ParentGroupName)")
					}
					else
					{
						echo "Parent direct member group was null - Parent: $($ParentGroupName) | Member: $($member)"
						
						$message = "This object directly underneath the Master Dl $($ParentGroupName) is not a group"
						$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
						Add-Content $log_file "$logMessage"
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
				 if($ParentGroupName) 
				 {
					if($Accounts) 
					{
						$Accounts.Split(",") | Foreach {
							$account = "$($_)".Trim()
							if($members.count -gt 0)
							{
								echo "Distribution List: $($ParentGroupName) <-> Account: $($account)"
								
								$message = "Api upload for $($account) with Master DL: $($ParentGroupName)"
								$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
								Add-Content $log_file "$logMessage"

  .\inactive_subs.ps1 -new_emails $new_emails -account_code $account -user $API_user -password $API_user_password -permission 'All' -useProxy $USE_PROXY -globalTag $globalTag								

$members | .\nw_sync_employees.ps1 -account_code $account -user $API_user -password $API_user_password -permission 'All' -tagsToBeCreated $tagsToBeCreated -useProxy $USE_PROXY
								#$members.keys | foreach { $members.Item($_).values | out-file -Append -FilePath ".\testOutput.txt" } # TODO - remove in production
							}
							else
							{
								echo "Sorry: List $($ParentGroupName) does not contain any users to upload!"
								
								$message = "Api upload skipped for $($account), no users found"
								$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
								Add-Content $log_file "$logMessage"
							}
		
						}
					}
					else
					{
						echo "Sorry no can do: The account code that should be mapped with this list $($ParentGroupName) does not exist in the mapping file.."
						
						$message = "Api upload failed, account code missing"
						$logMessage = "{0:yyyy-MM-dd hh:mm:ss}; $($message);" -f (get-date)
						Add-Content $log_file "$logMessage"
					}
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


