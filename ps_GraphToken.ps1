# Create a hashtable for the body, the data needed for the token request
# The variables used are explained above
$Body = @{
    'tenant' = 'a2a9bf31-fc44-425c-a6d2-3ae9379573ea'
    'client_id' = '599f2f05-2b85-4d68-93fe-4c46a659479c'
    'scope' = 'https://graph.microsoft.com/.default'
    'client_secret' = '_5E-83iv.2CIV672~6~S2dZS_jKKx.xZOg'
    'grant_type' = 'client_credentials'
}

# Assemble a hashtable for splatting parameters, for readability
# The tenant id is used in the uri of the request as well as the body
$Params = @{
    'Uri' = "https://login.microsoftonline.com/a2a9bf31-fc44-425c-a6d2-3ae9379573ea/oauth2/v2.0/token"
    'Method' = 'Post'
    'Body' = $Body
    'ContentType' = 'application/x-www-form-urlencoded'
}

$AuthResponse = Invoke-RestMethod @Params


$Headers = @{
    'Authorization' = "Bearer $($AuthResponse.access_token)"
}

<#$Result = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/users' -Headers $Headers

$Result = Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/reports/getteamsUserActivityUserCounts(period='D7')" -Headers $Headers -FollowRelLink

$Result -split "\?\?\?" -replace "﻿" | ConvertFrom-CSV
#>

$Periods = @('D7','D30','D90','D180')
#$Period = $Period.ToUpper()
$Period = 'D90'

$O365Reports = @(
    'getEmailActivityUserDetail';
    'getEmailActivityCounts';
    'getEmailActivityUserCounts';
    'getEmailAppUsageUserDetail';
    'getEmailAppUsageAppsUserCounts';
    'getEmailAppUsageUserCounts';
    'getEmailAppUsageVersionsUserCounts';
    'getMailboxUsageDetail';
    'getMailboxUsageMailboxCounts';
    'getMailboxUsageQuotaStatusMailboxCounts';
    'getMailboxUsageStorage';
    'getOffice365ActivationsUserDetail';
    'getOffice365ActivationCounts';
    'getOffice365ActivationsUserCounts';
    'getOffice365ActiveUserDetail';
    'getOffice365ActiveUserCounts';
    'getOffice365ServicesUserCounts';
    'getOffice365GroupsActivityDetail';
    'getOffice365GroupsActivityCounts';
    'getOffice365GroupsActivityGroupCounts';
    'getOffice365GroupsActivityStorage';
    'getOffice365GroupsActivityFileCounts';
    'getOneDriveActivityUserDetail';
    'getOneDriveActivityUserCounts';
    'getOneDriveActivityFileCounts';
    'getOneDriveUsageAccountDetail';
    'getOneDriveUsageAccountCounts';
    'getOneDriveUsageFileCounts';
    'getOneDriveUsageStorage';
    'getSharePointActivityUserDetail';
    'getSharePointActivityFileCounts';
    'getSharePointActivityUserCounts';
    'getSharePointActivityPages';
    'getSharePointSiteUsageDetail';
    'getSharePointSiteUsageFileCounts';
    'getSharePointSiteUsageSiteCounts';
    'getSharePointSiteUsageStorage';
    'getSharePointSiteUsagePages';
    'getSkypeForBusinessActivityUserDetail';
    'getSkypeForBusinessActivityCounts';
    'getSkypeForBusinessActivityUserCounts';
    'getSkypeForBusinessDeviceUsageUserDetail';
    'getSkypeForBusinessDeviceUsageDistributionUserCounts';
    'getSkypeForBusinessDeviceUsageUserCounts';
    'getSkypeForBusinessOrganizerActivityCounts';
    'getSkypeForBusinessOrganizerActivityUserCounts';
    'getSkypeForBusinessOrganizerActivityMinuteCounts';
    'getSkypeForBusinessParticipantActivityCounts';
    'getSkypeForBusinessParticipantActivityUserCounts';
    'getSkypeForBusinessParticipantActivityMinuteCounts';
    'getSkypeForBusinessPeerToPeerActivityCounts';
    'getSkypeForBusinessPeerToPeerActivityUserCounts';
    'getSkypeForBusinessPeerToPeerActivityMinuteCounts';
    'getteamsDeviceUsageUserDetail';
    'getteamsDeviceUsageUserCounts';
    'getteamsDeviceUsagedistributionUserCounts';
    'getteamsUserActivityUserDetail';
    'getteamsUserActivityCounts';
    'getteamsUserActivityUserCounts';
    'getYammerActivityUserDetail';
    'getYammerActivityCounts';
    'getYammerActivityUserCounts';
    'getYammerDeviceUsageUserDetail';
    'getYammerDeviceUsageDistributionUserCounts';
    'getYammerDeviceUsageUserCounts';
    'getYammerGroupsActivityDetail';
    'getYammerGroupsActivityGroupCounts';
    'getYammerGroupsActivityCounts'
)

foreach ($Report in $O365Reports)
{
    $Result = $null
    $ReportName = $null
    
    #Shorten report name due to Excel limits
    $ReportName = $Report.ToLower()
    $ReportName = $ReportName.replace('peertopeer','p2p')
    $ReportName = $ReportName.replace('skypeforbusiness','sfb')
    $ReportName = $ReportName.replace('office365','o365')
    $ReportName = $ReportName.replace('minute','min')
    $ReportName = $ReportName.replace('distribution','dist')
    $ReportName = $ReportName.replace('get','')
    $ReportName = $ReportName.replace('counts','')	


    if($Periods -notcontains $Period -or $Report -like "getOffice365Activation*"){
        $Result = Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/reports/$($Report)" -Headers $Headers -FollowRelLink  
    }
    else{
        $Result = Invoke-RestMethod -Uri "https://graph.microsoft.com/beta/reports/$($Report)(period='$($Period)')" -Headers $Headers -FollowRelLink   
    }

    if($Result){
        $Result = $Result.replace("﻿","") | ConvertFrom-Csv | Out-GridView -Title $ReportName
        }    
}

