<#
.SYNOPSIS
    This script gets currently active subscribers e-mail addresses from a Newsweaver account, compares these addresses to e-mail addresses for import,
	if the e-mail addresses which are currently active do not occur in the most recent import, make these records inactive, in the specified account

.DESCRIPTION

.NOTES
    File Name           : inactivate_subs.ps1
    Author              : Robert O'Brien
    Prerequisite   		: PowerShell V2
    Copyright      		: Poppulo 2017
	Version        		: V1.01

	$LastChangedBy: robrien $
	$LastChangedDate: 2017-09-21 10:55:00 +0000 (Thu, 21 Sept 2017)
    $.LINK
    http://www.poppulo.com
#>

Param(
    [Parameter(Mandatory=$True,Position=1)]
    [array] $new_emails,
    [Parameter(Mandatory=$True,Position=2)]
    [string]$account_code,
    [Parameter(Mandatory=$True,Position=3)]
    [string]$user,
    [Parameter(Mandatory=$True,Position=4)]
    [string]$password,
    [Parameter(Mandatory=$True,Position=5)]
    [string]$permission,
	  [Parameter(Mandatory=$False,Position=6)]
	  [boolean]$useProxy,
    [Parameter(Mandatory=$True,Position=7)]
    [string]$globalTag
)

#Include Newsweaver Api Functions
. ./nw_api.ps1

# Find the values which do not exist in a separate array
function get_difference($new_emails, $currently_active_emails) {
	$to_inactivate = New-Object System.Collections.ArrayList
	Write-Host "###########################"
	Write-Host "NEW EMAILS: $($new_emails)"
	Write-Host "###########################"
	Write-Host "EMAILS CURRENTLY IN ACCOUNT: $($currently_active_emails)"
	# Compare arrays, retrun e-mail addresses which do not exist in current import

   # loop the email addresses
   foreach ($current_in_acc in $currently_active_emails) {
   # used as a marker to see if the email address has been found or not
   $index = 0
    foreach ($email in $new_emails) {
      if($email -eq $current_in_acc) {
         $index = 1
     }
    }
    if($index -eq 0) {
       $email_value  = $current_in_acc
       #write-host "email value: $($email_value)"
       $capture = $to_inactivate.Add($email_value)
     }
    }

	#Write-Host "###########################"
	#Write-Host "TO INACTIVATE:$($to_inactivate)"
	#Write-Host "###########################"

	return $to_inactivate
}

# This hash will be populated with the subscriber data to be inactivated
$import_data = @{}
# Emails which do not exist in the current import, assign a status of "Inactive" and pipe inactive subscribers to the specified account
function assign_inactive_status($to_inactivate) {
	foreach($email in $to_inactivate) {
		$inactivate_list = @{}
		$inactivate_list.Set_Item("Email","$($email)")
		$inactivate_list.Set_Item("enabled",$false)
       # $inactivate_list.Set_Item("Tags","API - Inactivated")
		$import_data.Set_Item("$($email)",$inactivate_list)
	}
	#$output = $import_data | Out-String
	#Write-Host "Inactivation data: $($output)"
	return $import_data
}

# Get an xml response of subscriber data, for the specified NW account
function get_email_addresses($resource_url, $account_code, $API_user, $API_user_password, $timeout, $USE_PROXY) {

$email_document = nw_get  $resource_url $account_code $API_user $API_user_password $timeout $USE_PROXY

return $email_document
}

# import the config.xml file containing the relevant user data, username/password etc...
$config = Import-CliXML nw-config.xml
# import some detail from the "normal" Newsweaver config file
$API_user = $config["API_USER"]
$API_user_password = $config["API_PASSWORD"]
$USE_PROXY = $config["USE_PROXY"]

if($USE_PROXY.ToLower() -eq 'true')
{
	$USE_PROXY = $true
}
else
{
	$USE_PROXY = $false
}

# Array to store the email addresses from the specified account
$emails = @()

# Build the URI for retrieving data
$link = "https://api.newsweaver.com/v2/"
#$account = "$($Account)"
#$account_code = "newsweavertest"

# When retrieving subscriber data, you can specify a sub-set of data
$tag = $globalTag
#$tag = $urlTagName
$saved_search = "?search=SavedSearchName=all"
# URI to pull an XML response of subscriber data
$resource_url = $link + $account_code + "/subscribers" + "?tags=" + $tag # + $saved_search
write-host "URL" $resource_url
# Gather XML subscriber data for the relevant account
$email_document  = get_email_addresses $resource_url $account_code $API_user $API_user_password 60000 $USE_PROXY

# Below, output XML response, contains subscribers information
#Write-Host "RESPONSE: $($email_document)"

# Gather all e-mail addresses found in the XML response, store e-mail addresses in an array "$emails"
$emails = Select-Xml -Content $email_document -Xpath "//subscribers/subscriber/email" | foreach {$_.node.InnerXml}
#Write-Host "Found:"$emails

# While e-mail address exist in the relevant account (with a specific tag name, possibly
while($emails.count -gt 0) {

	# provide the xpath to the link for the next page of subscribers
	$query = "//link[@rel='next']/@href"
	# Get the link text for the next page of subscriber data
	$link = $email_document | Select-Xml $query
	#Write-Host "Link: $($link)"

	# If there is a anext page of subscriber data
	if($link) {
		# Write-Host "Finding new Email Addresses"
		# Reassign the preceeding pages of subscriber data to the variable $email_document
		$email_document  = get_email_addresses "$($link)" $account_code $API_user $API_user_password 60000 $USE_PROXY
		# Gather all e-mail addresses found in the XML response, APPEND e-mail addresses the array "$emails"
		$emails += Select-Xml -Content $email_document -Xpath "//subscribers/subscriber/email" | foreach {$_.node.InnerXml}
	}
	# If a 'next page' does not exist, break the while loop
	Else{
		Write-Host "No more email addresses found."
		Write-Host $emails.count
		break
	}
}


    #write-host "Piped Emails $new_emails"
	# "get_difference" receives two arrays, $new_emails is an array of emails for import, $currently_active_emails is an array of e-mails currently active in the specified account
	$to_inactivate = get_difference $new_emails $emails

	# e-mail address which do not exist in the import, are assign a status of "Inactive", to be imported as Inactive
	$import_data = assign_inactive_status $to_inactivate
	$output_list = $import_data | Out-String
	Write-Host "INACTIVATE LIST:" $output_list

	# $safety_net = half the total number of currently active subscribers
	$saftey_net = $emails.length / 2
    if($to_inactivate -ne $null){
	    # If the number of subscribers to inactivate is greater than half the number of currently active subscribers, do not inactivate the subscribers, continue with the import.
	    if($import_data.count -ge $saftey_net){
	    Write-Host "The number of e-mails to inactivate, is more than double the number of currently active subscribers within the account. For safety, no subscribers will become inactive."
	    }
	    else{
	    # WILL NEED TO PASS EMAIL LIST ARRAY WITH INACTIVE STATUS TO nw_sync_employees, this will then inactivate the subscribers
	    Write-Host "Inactivating subscribers."
	    $import_data| ./nw_sync_employees.ps1 -account_code $account_code -user $API_user -password $API_user_password -permission $permission -useProxy $USE_PROXY
	    }
    }
    else{
        Write-Host "No data clean up required."
    }

# Continue with import
