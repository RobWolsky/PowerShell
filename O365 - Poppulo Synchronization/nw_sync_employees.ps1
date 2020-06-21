<#
.SYNOPSIS
    This script syncs ActiveDirectory users with the Newsweaver system

.DESCRIPTION

.NOTES
    File Name               : nw_sync_employees.ps1
    Author                  : Newsweaver
    Prerequisite   			: PowerShell V2
    Copyright      			: Newsweaver 2015
	Version        			: V1.06

	$LastChangedBy: josullivan $
	$LastChangedDate: 2015-02-03 17:20:40 +0000 (Tue, 03 Feb 2015) $
	$Revision: 54111 $
.LINK
    http://www.newsweaver.com
#>

Param(
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
    [HashTable]$employees_list,
    [Parameter(Mandatory=$True,Position=1)]
    [string]$account_code,
    [Parameter(Mandatory=$True,Position=2)]
    [string]$user,
    [Parameter(Mandatory=$True,Position=3)]
    [string]$password,
    [Parameter(Mandatory=$True,Position=4)]
    [string]$permission,
	  [Parameter(Mandatory=$False,Position=5)]
	  [Object[]]$tagsToBeCreated,
    [Parameter(Mandatory=$False,Position=6)]
    [string]$remove_tags,
	  [Parameter(Mandatory=$False,Position=7)]
	  [boolean]$useProxy
)

#Import-Module ActiveDirectory

#Include Newsweaver Api Functions
. ./nw_api.ps1

$removeTagFromSubscribers = New-Object System.Collections.ArrayList

$template_xml="<subscriber_import_job>
    <accept_terms>true</accept_terms>
    <update_existing>true</update_existing>
    <reactivate_api_removed>true</reactivate_api_removed>
    <reactivate_admin_removed>true</reactivate_admin_removed>
    <reactivate_bounced_removed>false</reactivate_bounced_removed>
    <subscriber_data>
        <skip_first_line>false</skip_first_line>
        <field_separator>comma</field_separator>
    </subscriber_data>
</subscriber_import_job>"

$template_tag_xml="<tag>
</tag>"

$tagsToBeDeleted = @()

$logFolder = "Log\$($today.year)$($today.month)$($today.day)"
if((Test-Path $logFolder -PathType container) -eq $False)
{
	New-Item -ItemType directory -Path $logFolder
}
$log_file = "$($logFolder)\{0:yyyy-MM-dd_hhmmss}_api_execution.log" -f (get-date)
$employee_file = "$($logFolder)\{0:yyyy-MM-dd_hhmmss}_employeeXml.log" -f (get-date)
$employee_backup_file = "$($logFolder)\{0:yyyy-MM-dd_hhmmss}_backupEmployeeList.txt" -f (get-date)

Set-Content $log_file "timestamp;action;object"
$logmsg = $null


#*****************Deprecated*****************#
# convert the member of string in to comma separated list of names
# Basically the regex ..= split just takes out the dc= bit or any two chars before a =
# returns an array and then we just rejoin the array back into a string
function get_groups($memberof){
    return $memberof -split "..=" -join "";
}

# Create a Newsweaver tag (create|delete|update) job xml
function create_tag_job($tag){
	#Create an XML Object from a template
	$tags_xml = New-Object System.XML.XmlDocument
	$tags_xml.LoadXml($template_tag_xml.Clone())

	#get the tag name from the $tag parameter
	$name = $tags_xml.CreateElement("name")
	$name.innerText = "$($tag)"

	#Capture the output of this function or it will be returned
	$capture = $tags_xml.SelectSingleNode("//tag").AppendChild($name)

	#get the tag description from the $tag parameter
	$description = $tags_xml.CreateElement("description")
	$description.innerText = "$($tag)"

	#Capture the output of this function or it will be returned
	$capture = $tags_xml.SelectSingleNode("//tag").AppendChild($description)

	$stringWriter = New-Object System.IO.StringWriter
	$xmlWriter = New-Object System.XMl.XmlTextWriter $stringWriter
	$xmlWriter.Formatting = "indented"
	$xmlWriter.Indentation = $Indent
	$tags_xml.WriteContentTo($xmlWriter)
	$xmlWriter.Flush()
	$stringWriter.Flush()

	$stringWriter.ToString()
}

function populateSubscriberColumnMapping()
{
	$subscriberColumnMapping = @()

	#Personal Details
	$subscriberColumnMapping += "email"
	$subscriberColumnMapping += 'name.first name'
	$subscriberColumnMapping += 'name.surname'
	$subscriberColumnMapping += 'personalDetails.preferredName'

	#Work Details
	$subscriberColumnMapping += 'company'
	$subscriberColumnMapping += 'externalId'
	$subscriberColumnMapping += 'position'
	$subscriberColumnMapping += 'workDetails.function'
	$subscriberColumnMapping += 'workDetails.team'
	$subscriberColumnMapping += 'workDetails.department'
	$subscriberColumnMapping += 'workDetails.division'
	$subscriberColumnMapping += 'workDetails.businessUnit'

	#Work Location
	$subscriberColumnMapping += 'workLocation.officeBuilding'
	$subscriberColumnMapping += 'workLocation.siteLocation'
	$subscriberColumnMapping += 'address.city'
	$subscriberColumnMapping += 'address.state/region'
	$subscriberColumnMapping += 'address.postal code'
	$subscriberColumnMapping += 'workLocation.region'
	$subscriberColumnMapping += 'address.country'

	#Custom fields
	#$subscriberColumnMapping += "example"

	#Status
	$subscriberColumnMapping += "status"

	#Tags
	$subscriberColumnMapping += "tags"

	#Remove Tags
	$subscriberColumnMapping += "removetags"

	return $subscriberColumnMapping
}

# Create an Newsweaver import subscribers job xml
function nw_create_import_job($employee_list, $tags){
	#Create an XML object from a template
	$employees_xml = New-Object XML
	$employees_xml.LoadXml($template_xml)

	#get the employees from ActiveDirectory
	$data = $employees_xml.CreateElement("data")
    $data.InnerText = $employee_list

    $columns = $employees_xml.CreateElement("columns")

	$subscriberColumns = populateSubscriberColumnMapping
    $columns.innerText = $subscriberColumns -join "`,"

	$replace_tags = $employees_xml.CreateElement("replace_tags")
	foreach ($tag in $tags)
	{
		$tag_xml = $employees_xml.CreateElement("tag")
		$tag_xml.SetAttribute("name",$tag)
		$capture = $replace_tags.AppendChild($tag_xml)
	}

	$capture = $employees_xml.subscriber_import_job.AppendChild($replace_tags)

	# Capture the output of this function or it will be returned
	$capture = $employees_xml.subscriber_import_job.subscriber_data.AppendChild($columns)
	$capture = $employees_xml.subscriber_import_job.subscriber_data.AppendChild($data)

	# Add the Newsweaver permisson for the imported subscribers
	$add_permissions_tag = $employees_xml.CreateElement("add_permissions")
	$permission_tag = $employees_xml.CreateElement("permission")
    $permission_tag.SetAttribute("name",$permission)
	$capture = $add_permissions_tag.AppendChild($permission_tag)
    $capture = $employees_xml.subscriber_import_job.AppendChild($add_permissions_tag)

	$StringWriter = New-Object System.IO.StringWriter
	$XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter
	$xmlWriter.Formatting = "indented"
	$xmlWriter.Indentation = $Indent
	$employees_xml.WriteContentTo($XmlWriter)
	$XmlWriter.Flush()
	$StringWriter.Flush()

	$StringWriter.ToString()
}

function waitForImportToComplete($resource_url) {
	$startTime = Get-Date
	$nextTime = $null
	$currentTime = Get-Date
	Write-Host "Waiting for Subscriber Import $($resource_url)"
	$continue = $true

	while($continue) {
		$currentTime = Get-Date
		Write-Host "next time: $($nextTime); current time: $($currentTime)"
		if(($nextTime -eq $null) -or ($currentTime -gt $nextTime)) {
			$resource = nw_get $resource_url $account_code $user $password 60000 $useProxy
			$resource_xml = New-Object XML
			$resource_xml.LoadXml($resource)

			$status = ($resource_xml.subscriber_import | select status).status

			Sleep 1
			if($status -eq 'IN_PROGRESS') {
				$progress = $resource_xml.subscriber_import.progress
				$nextTime = Get-Date "$($progress.ping_after)"
				$records_processed = $progress.records_processed
				$total_records = $progress.total_records
				Write-Host "Status: $($status), progress: $($records_processed) / $($total_records)"
			} else {
				if(!$status -eq 'COMPLETED') {
					Write-Host "ERROR: Subscriber Import did not complete successfully!\nStatus is $($status)"
				}

				Write-Host "Subscriber import finished with status $($status):"
				Write-Host "Total   : $($resource_xml.subscriber_import.results.total_records)"
				Write-Host "New     : $($resource_xml.subscriber_import.results.new_subscribers)"
				Write-Host "Updated     : $($resource_xml.subscriber_import.results.updated_subscribers)"
				Write-Host "Invalid     : $($resource_xml.subscriber_import.results.invalid_records)"
				Write-Host "Previously Opted Out     : $($resource_xml.subscriber_import.results.previously_opted_out)"
				$continue = $false
			}
		}
	}
}

function buildEmployee($employee) {

	$record = @()
	#---------------
	# Personal Details
	#---------------

	$email = " "
	if($employee.Email) {	$email = "`""+$employee.Email+"`"" 	}
	$record += $email

	$firstName = " "
	if($employee.FirstName) { $firstName = "`""+$employee.FirstName+"`"" }
	$record += $firstName

	$lastName = " "
	if($employee.LastName) { $lastName = "`""+$employee.LastName+"`""}
	$record += $lastName

	$preferredName = " "
	if($employee.PreferredName) { $preferredName = "`""+$employee.PreferredName+"`"" }
	$record += $preferredName

	#---------------
	# Work Details
	#---------------

	$company = " "
	if($employee.Company) { $company ="`""+$employee.Company+"`"" }
	$record += $company

	$employeeNumber = " "
	if($employee.EmployeeNumber) { $employeeNumber ="`""+$employee.EmployeeNumber+"`"" }
	$record += $employeeNumber

	$title = " "
	if($employee.Title) { $title ="`""+$employee.Title+"`"" }
	$record += $title

	$jobFunction = " "
	if($employee.JobFunction) { $jobFunction ="`""+$employee.JobFunction+"`"" }
	$record += $jobFunction

	$team = " "
	if($employee.Team) { $team ="`""+$employee.Team+"`"" }
	$record += $team

	$department = " "
	if($employee.Department) { $department ="`""+$employee.Department+"`"" }
	$record += $department

	$division = " "
	if($employee.Division) { $division ="`""+$employee.Division+"`"" }
	$record += $division

	$businessUnit = " "
	if($employee.BusinessUnit) { $businessUnit ="`""+$employee.BusinessUnit+"`"" }
	$record += $businessUnit

	#---------------
	# Work Location
	#---------------

	$office = " "
	if($employee.Office) { $office ="`""+$employee.Office+"`"" }
	$record += $office

	$site = " "
	if($employee.Site) { $site ="`""+$employee.Site+"`"" }
	$record += $site

	$city = " "
	if($employee.City) { $city ="`""+$employee.City+"`"" }
	$record += $city

	$state = " "
	if($employee.State) { $state ="`""+$employee.State+"`"" }
	$record += $state

	$postCode = " "
	if($employee.PostCode) { $postCode ="`""+$employee.PostCode+"`"" }
	$record += $postCode

	$region = " "
	if($employee.Region) { $region ="`""+$employee.Region+"`"" }
	$record += $region

	$country = " "
	if($employee.Country) { $country ="`""+$employee.Country+"`"" }
	$record += $country

	#---------------
	# Custom Fields
	#---------------

	#$example = " "
	#if($employee.Example) { $example = "`""+$employee.Example+"`"" }
	#$record += $example

	#-----------------
	# Employee status
	#-----------------

	$status = 'ACTIVE'
	if($employee.enabled -eq $False) {$status = "INACTIVE"}
	$record += $status

	#---------------
	# Employee Tags
	#---------------

	$tags=" "
	if($employee.Tags)
	{
		$tArray = @()
		foreach($entry in $employee.Tags)
		{
			$tArray += "$($entry)"
		}
		$str = $tArray -split "..=" -join ","
		$tags = "`""+$str+"`""
	}
	$record += $tags

	#---------------
	# Remove Tags
	#---------------

	$quoted_remove_tags= ""
	$record += $quoted_remove_tags

	# Combine the employee details in to a single line string
	$line = ($record -join ",") + "`n"
	return $line
}

function create_tag($tag)
{
	$xml = create_tag_job($tag)
	nw_create '/tags' $account_code $user $password $xml.ToString() 60000 $useProxy
	$logmsg = "{0:yyyy-MM-dd hh:mm:ss};tag $($tag) created;" -f (get-date)
	Add-Content $log_file "$logmsg"
}
<#
	# Start of script
	$tagsToBeCreated = $tagsToBeCreated | select -Unique
	forEach($tag in $tagsToBeCreated) {
		create_tag("$($tag)")
	}
#>
	$subscriberColumns = populateSubscriberColumnMapping
	# Get the list of employees from the command-line that are piped to us
	$employees_list.GetEnumerator() | % {
		$employee = $_.VALUE
		$line = buildEmployee($employee)

		# Collect all the employees with one per line
		$employee_list += $line
	}

	$backup_list = $employee_list -join "`n"
	$backup_list = $backup_list -replace '-pending',''
	Add-Content $employee_backup_file $backup_list

	# Create the xml file from the list of employees
	$xml = nw_create_import_job $employee_list $tagsToBeCreated

	Add-Content $employee_file "$xml"


	    # Call Newsweaver API with the XML file
	    # Note that you may need to alter the timeout value if you get no response from the script
	    $res_xml = nw_create '/subscriber_imports' $account_code $user $password $xml.ToString() 60000 $useProxy
	    $logmsg = "{0:yyyy-MM-dd hh:mm:ss};Subscriber Import: $($employees_list.Count) subscribers ;" -f (get-date)
	    Add-Content $log_file "$logmsg"

	    #Create an XML object so we can get the status code from API response
	    #The returned code should be 202 (202 is the HTTP Status code for Accepted)


        $res = New-Object XML
	    $res.LoadXml($res_xml)
	    $status_code = $res.status.code
	    if($status_code -eq 200 -or $status_code -eq 202) {
		    $resource_url = $res.status.resources_created.link.href
		    waitForImportToComplete $resource_url
	    } else {
		    Write-Host $res_xml
		    $logmsg = "{0:yyyy-MM-dd hh:mm:ss};ERROR! $($res_xml) ;" -f (get-date)
		    Add-Content $log_file "$logmsg"
	    }

<#
	forEach($tag in $tagsToBeCreated)
	{
		$xml = create_tag_job("$($tag)")
		nw_delete "/tag/$($tag)" $account_code $user $password $xml.ToString() 60000 $useProxy
		$logmsg = "{0:yyyy-MM-dd hh:mm:ss};tag $($tag) deleted;" -f (get-date)
		Add-Content $log_file "$logmsg"

		nw_update "/tag/$($tag)-pending" $account_code $user $password $xml.ToString() 60000 $useProxy
		$logmsg = "{0:yyyy-MM-dd hh:mm:ss};tag $($tag) updated;" -f (get-date)
		Add-Content $log_file "$logmsg"
	}
#>
