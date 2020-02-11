#Syntax to connect to EAC on Hybrid server and force 2013 (useful if I have a 2010 mailbox)
#https://CAS15-NA/ecp/?ExchClientVer=15


#Properties to expose AccessRights as Array
get-mailbox "rxw1401*" | Get-MailboxPermission | Select User,AccessRights | FT
get-EXLmailbox "OPR2036" | Get-EXLMailboxPermission | ? {($_.AccessRights -like “*FullAccess*”) -and ($_.IsInherited -eq $false) -and ($_.User -notlike “NT AUTHORITY\SELF”) -and ($_.User -notlike "S-1-5*") -and ($_.User -notlike $Mailbox.PrimarySMTPAddress)} | Select User,AccessRights | FT

#Properties to expose GrantSendOnBehalfTo 
Get-Mailbox -ResultSize 300 | ? {$_.GrantSendOnBehalfTo} | Select DisplayName, Name, GrantSendOnBehalfTo | Out-GridView

#Command to get what I need from Get-AdUser
get-aduser -Filter "*" -Properties DisplayName, Mail, Manager, Office | Select DisplayName, Name, UserPrincipalName, Mail, Office, Manager | Out-GridView

#Command to get IFF Service accounts
Get-ADUser -Filter 'Name -like "*_*"' -Properties DisplayName, Manager, Office | Select Name, DisplayName, UserPrincipalName, Office, Manager | Sort Name | Out-GridView


#Command to get what I need from Get-ADPermission (ExtendedRights holds Send-As)
Get-ADPermission -Identity rxw1401 | ? {$_.ExtendedRights} | Select User,Identity,ExtendedRights | FT

#Command to export Mailbox "Name" field for import to sendas script
Get-Mailbox -ResultSize unlimited | Select Name | Export-CSV -Path 'c:\Temp\sendas.csv' -notype

#Get the resource Mailboxes, with ResourceType
Get-Mailbox -ResultSize unlimited | ? {$_.IsResource} | Select Name, DisplayName, SAMAccountName, IsResource, ResourceType | Out-GridView

#Get the Shared Mailboxes. IFF uses CustomAttribute15 to tag shared mailboxes.
Get-Mailbox -ResultSize unlimited | ? {($_.CustomAttribute15 | Out-String).Contains("Shared")} | Select Name, DisplayName, UserPrincipalName, SAMAccountName, OrganizationalUnit, CustomAttribute15 | Out-GridView

#Find Mailbox and MailUser objects for distribution lists
Get-Recipient -RecipientType UserMailbox -ResultSize 100 | Select Name, SamAccountName, PrimarySMTPAddress, RecipientType, OrganizationalUnit | Out-GridView
Add-DistributionGroupMember -Identity "AllUsersPHTPEmpPSTest" -Member $a.PrimarySMTPAddress
$a = Get-Recipient -RecipientType MailUser, UserMailbox -OrganizationalUnit global.iff.com/IFF/NA/US/PH/EMPLOYEE | Select Name, SamAccountName, PrimarySMTPAddress, RecipientType, OrganizationalUnit #| Out-GridView
Update-DistributionGroupMember -Identity "AllUsersPHTPEmpPSTest" -Members $a.PrimarySMTPAddress -Confirm:$false

#ISE Setup Commands
RemoteExchange.ps1                                                                                   
add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010                                            
Set-EXLAdServerSettings -ViewEntireForest $True                                 
#Connect-ExchangeServer - auto

#$UserCredential = Get-Credential "axc1935@global.iff.com"
$UserCredential = Get-Credential "rxw1401_e@global.iff.com"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $UserCredential -Authentication Basic -AllowRedirection 

Import-PSSession $Session -AllowClobber

#Need Microsoft Sign-in assistant
#Need PowershellGet
Import-Module AzureAD
Import-Module MSOnline

Connect-MsolService -Credential $UserCredential
Connect-AzureAD -Credential $UserCredential



 #Get-Module -ListAvailable
 #Get-Command -Module PackageManagement



$ExSession = New-PSSession –ConfigurationName Microsoft.Exchange –ConnectionUri ‘http://mail.global.iff.com/PowerShell/?SerializationLevel=Full’ -Credential $UserCredential –Authentication Negotiate


# Get-MailboxFolderPermission -identity "rxw1401:\calendar"

#Get-MailboxFolderPermission


#Get-Mailbox For Master Migration Data Updates
Get-EXLMailbox -ResultSize Unlimited -RecipientType UserMailbox | Select Name, PrimarySMTPAddress, UserPrincipalName, RecipientType | Sort Name | Out-GridView

#Get-MailboxFolder

Get-EXLDistributionGroup | ? {($_.DisplayName | Out-String).Contains("Employee")} | Select Alias, OrganizationalUnit
Get-EXLOrganizationalUnit -SearchText "EMPLOYEE" | ? {($_.CanonicalName | Out-String) -notlike "*NO**"} | Select CanonicalName | Sort-Object CanonicalName | Out-GridView
Get-EXLOrganizationalUnit -SearchText "EMPLOYEE" | Select DistinguishedName| Sort-Object DistinguishedName | Out-GridView
Get-ADuser -Filter * -SearchBase $_objectItem.DistinguishedName -SearchScope OneLevel  | measure | select Count  
New-DistributionGroup -Name "exPS" -DisplayName "exPS" -Alias "exPS" -OrganizationalUnit "global.iff.com/IFF/NA/US/PH/Exchange/ExGroups" -ManagedBy "llm7786" -Notes "Group created to replace dynamic distribution lists. See Louis Muniz" -Type "Distribution" -Confirm:$False



#Certificate Removal
## This can be a remote PC name as well
$pc = '.'
$cert_store = 'My'
 
$store = New-Object system.security.cryptography.X509Certificates.X509Store ("\$pcMy"),'LocalMachine' #LocalMachine could also be LocalUser
$store.Open('ReadWrite')
## Find all certs that have an Issuer of my old CA
$certs = $store.Certificates # | ? {$_.Issuer -eq 'CN=HOST.DOMAIN.COM, DC=DOMAIN, DC=EXT'}
## Remove all the certs it finds
$certs | % {$store.Remove($_)}

#Complete individual mailbox from within a migration batch
Get-MoveRequest -Identity mailbox@domain.com | Set-MoveRequest -SuspendWhenReadyToComplete:$false -preventCompletion:$false -CompleteAfter 5
Get-MoveRequest -Identity mailbox@domain.com | Resume-MoveRequest

#Test DDL replacement scripts
New-EXLDistributionGroup -Name "exPS_All_TESTPSSCRIPT_RW" -DisplayName "exPS_All_TESTPSSCRIPT_RW" -Alias "exPS_AllUS_TESTRW" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
Set-EXLDistributionGroup -Identity "exPS_All_TESTPSSCRIPT_RW" -HiddenFromAddressListsEnabled:$True



$user1 = get-aduser -Identity "rxw1401" -Properties "Certificates"
$user1.Certificates

Get-EXLMailbox -Arbitration | FL Name,DisplayName,ServerName,Database,AdminDisplayVersion
Search-EXLAdminAuditLog -Cmdlets Add-EXLMailboxPermission

Get-exlManagementRoleAssignment -Role "Mail Recipients" -GetEffectiveUsers | Out-GridView


get-exomoverequest -movestatus Failed #|get-exomoverequeststatistics|select DisplayName,SyncStage,Failure*,Message,PercentComplete,largeitemsencountered,baditemsencountered|ft -autosize

Resume-exomoverequest 'Jackie Chan'

get-exomoverequest -Batchname "MigrationService:2017Dec15_ITPilot" | Get-EXOMoveRequestStatistics | Select DisplayName, Identity, Status, StatusDetail, TotalMailboxSize, PercentComplete | Out-GridView

New-MoveRequest -Identity "INSERT_USER_ALIAS_HERE" -Remote -RemoteHostName "webmail.iff.com" -TargetDeliveryDomain iff.mail.onmicrosoft.com -RemoteCredential $LocalCredential -BadItemLimit 1000


#License commands
Get-MsolAccountSku
Get-MsolUser -All -UnlicensedUsersOnly
Get-MsolUser -All | where {$_.UsageLocation -eq $null}
Set-MsolUser -UserPrincipalName "<Account>" -UsageLocation <CountryCode>
Set-MsolUserLicense -UserPrincipalName "<Account>" -AddLicenses "IFF:STANDARDPACK"
$x = Get-MsolUser -All -UnlicensedUsersOnly [<FilterableAttributes>]; $x | foreach {Set-MsolUserLicense -AddLicenses "IFF:STANDARDPACK"}
Get-MsolUser -MaxResults 100 | ? {($_.Licenses | Out-String) -notlike "*PACK*"} | Select UserPrincipalName, DisplayName, Licenses | Out-GridView
Get-MsolUser -MaxResults 100 | ?{$_.MSExchRecipientTypeDetails -eq $null} | Select DisplayName, MSExchRecipientTypeDetails | Out-GridView
Get-MsolUser -MaxResults 100 | ? {($_.BlockCredential -eq $true)}
Get-MsolUser -MaxResults 100 | % {get-aduser -Filter 'UserPrincipalName -eq $_.UserPrincipalName' -Properties iffCountryCode} | Select Name, iffCountryCode | Out-GridView
Set-MsolUserLicense -UserPrincipalName $user -AddLicenses "IFF:ENTERPRISEPACK" -RemoveLicenses "IFF:STANDARDPACK" 

Get-MsolUser -MaxResults 1000 | ? {(($_.Licenses | Out-String) -notlike "*PACK*") -and (($_.BlockCredential -ne $true) -and ($_.MSExchRecipientTypeDetails -ne $null)) } | Select DisplayName, Licenses, MSExchRecipientTypeDetails, BlockCredential | Out-GridView
Get-MsolUser -All | ? {(($_.Licenses | Out-String) -notlike "*PACK*") -and (($_.BlockCredential -ne $true) -and ($_.MSExchRecipientTypeDetails -ne $null) -and ($_.MSExchRecipientTypeDetails -eq 1)) } | Select DisplayName, Licenses, MSExchRecipientTypeDetails, BlockCredential | Out-GridView
$a = Get-MsolUser -All | ? {(($_.Licenses | Out-String) -notlike "*PACK*") -and (($_.BlockCredential -ne $true) -and ($_.MSExchRecipientTypeDetails -ne $null) -and ($_.MSExchRecipientTypeDetails -eq 1)) } ; $a | % {get-aduser -Filter 'UserPrincipalName -eq $_.UserPrincipalName' -Properties iffCountryCode} | Select Name, iffCountryCode | Out-GridView

#User Migration Commands
get-exomoverequest -Batchname "MigrationService:AzulRoom" | Get-EXOMoveRequestStatistics | Select DisplayName, Identity, Status, StatusDetail, TotalMailboxSize, PercentComplete | Out-GridView
New-EXOMoveRequest -Identity "rxw1401" -Remote -RemoteHostName "webmail.iff.com" -TargetDeliveryDomain iff.mail.onmicrosoft.com -RemoteCredential $LocalCredential -BadItemLimit 1000

Get-EXOMoveRequest "Eddie Rosado" | Set-EXOMoveRequest -SuspendWhenReadyToComplete:$false
Get-EXOMoveRequest "Eddie Rosado" | Resume-EXOMoveRequest

#Hybrid Migration Template Commands
New-MoveRequest -Identity alias -remote -RemoteHostName hybridURL.company.com -TargetDeliveryDomain company.mail.onmicrosoft.com -RemoteCredential $onprem -BadItemLimit 50 –SuspendWhenReadyToComplete
Get-MoveRequest | where {$_.status -notlike “complete*”} | Get-MoveRequestStatistics | Select DisplayName,status,percentcomplete,itemstransferred
Get-MoveRequest | where {$_.status -notlike “complete*”} | Get-MoveRequestStatistics | Select DisplayName,status,percentcomplete,itemstransferred,BadItemsEncountered
Get-MoveRequest “User, Mail” | Resume-MoveRequest

# This command will complete all of the move requests that are in auto suspend:
Get-MoveRequest -MoveStatus AutoSuspended | Resume-MoveRequest

#Modern Authentication
Get-CsOAuthConfiguration | Format-Table ClientAdal* 
Get-EXOOrganizationConfig | Format-Table -Auto Name,OAuth*

#Skype for Business Hybrid User Migration
Move-CsUser -Identity evan.kanter@iff.com -Target sipfed.online.lync.com -Credential $CloudCred -HostedMigrationOverrideUrl "https://admin1a.online.lync.com/HostedMigration/hostedmigrationservice.svc" -Confirm:$False
Move-CsUser -Identity testuser@contoso.com -Target sipfed.online.lync.com -Credential $CloudCred -HostedMigrationOverrideUrl https://admin1a.online.lync.com/HostedMigration/hostedmigrationservice.svc
$a = get-content 'C:\Temp\ITusers.txt'
$a | % {Move-CsUser -Identity $_ -Credential $CloudCred -Target sipfed.online.lync.com -HostedMigrationOverrideUrl "https://admin1a.online.lync.com/HostedMigration/hostedmigrationservice.svc" -Confirm:$False}


#Skype for Business move users from a specific OU
Get-CsUser -OU "cn=hybridusers,cn=contoso." | Move-CsUser -Target sipfed.online.lync.com -Credentials $creds -HostedMigrationOverrideUrl https://admin1a.online.lync.com//HostedMigration/hostedmigrationservice.svc

#Skype for Business Hybrid User Migration - Create a .csv list of all users to move
Get-CsUser -Identity |Select -Property DisplayName, SipAddress, EnterpriseVoiceEnabled, Identity | Export-Csv c:\allskypeusers.csv
 
$creds=Get-Credential
 
$user_to_skype = Import-Csv C:\allskypeusers.csv
 
$user_to_skype | % { Move-CsUser -Identity $_.SipAddress -Target sipfed.online.lync.com -Credential $creds -HostedMigrationOverrideUrl https://admin1a.online.lync.com//HostedMigration/hostedmigrationservice.svc
                     Write-host "User " $_.DisplayName " Migrated OK" -ForegroundColor Green
}



#If no server or pool was passed when the script executed, pop up a box and ask for it.
if ($poolname -eq $null){
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$poolname = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a Pool or Server to connect to", "Remote Lync Pool or Server", "")
}

#Find Skype Cmdlets assigned to each role
Get-CsAdminRole -Identity "CsHelpDesk" | Select-Object -ExpandProperty Cmdlets

get-mailbox | where {($_.recipienttypedetails -ne “Discoverymailbox”) -and ($_.skuassigned -ne “True”)} | ft name,skuassign*

get-exomailbox | Select DisplayName, Identity, PrimarySMTPAddress, MailboxMoveStatus, WhenMailboxCreated | Out-GridView

get-aduser -Filter { (Title -like "VP*") -or (title -like "Vice President*" ) -or (title -like "V.P.*" ) -or (title -like "EVP*" ) -or (title -like "SVP*" )} -Properties DisplayName, Title, Mail, Office | Select DisplayName, Name, Title, UserPrincipalName, Mail, Office | Out-GridView

Get-ADUser -Identity nxm5240 -Properties directreports | Select-Object -ExpandProperty DirectReports | % {Get-Aduser $_ -Properties DisplayName, Title} | Out-GridView


Set-EXOCalendarProcessing -Identity 'lavender.surface@iff.com' -AutomateProcessing AutoAccept -AddOrganizerToSubject $false –AllowConflicts $false –DeleteComments $false -DeleteSubject $false -RemovePrivateProperty $false
Set-EXOCalendarProcessing -Identity 'lavender.surface@iff.com' -AddAdditionalResponse $true -AdditionalResponse 'This is a Surface Hub room!'

Get-CsOnlineUser -Filter 'DisplayName -like "*Polycom*"' | Select DisplayName, SipAddress, HostingProvider, RegistrarPool | Out-GridView


#Manually check complexity
Get-exlMailboxFolderPermission -identity "Palm Oil:\calendar"
Get-E10ADPermission -Identity "Palm Oil" | ? {$_.ExtendedRights} | Select User,Identity,ExtendedRights | FT
Get-EXLADPermission -Identity "Palm Oil" | ? {$_.ExtendedRights} | Select User,Identity,ExtendedRights | FT
Get-EXLMailbox "Palm Oil" | ? {$_.GrantSendOnBehalfTo} | Select DisplayName, Name, GrantSendOnBehalfTo | Out-GridView
get-EXLmailbox "Palm Oil" | Get-EXLMailboxPermission | Select User,AccessRights | FT
get-EXLmailbox "Palm Oil" | Get-EXLMailboxPermission | ? {($_.AccessRights -like “*FullAccess*”) -and ($_.IsInherited -eq $false) -and ($_.User -notlike “NT AUTHORITY\SELF”) -and ($_.User -notlike "S-1-5*") -and ($_.User -notlike $Mailbox.PrimarySMTPAddress)} | Select User,AccessRights | FT

# Office 365 Shared Group settings prior to migration
get-adgroup -Filter * -SearchBase "OU=exGroups,OU=Exchange,OU=IFF,DC=global,DC=iff,DC=com" -SearchScope Subtree | ? {$_.GroupScope -eq "Global"} #| Select Name, GroupCategory, GroupScope | Sort Name | Out-GridView
get-adgroup -Identity TilburgFlavorsPackingRoomEditors | Set-ADGroup -GroupScope Universal

Enable-EXLDistributionGroup -identity TechInfoUnileverEditors
Get-EXLDistributionGroup -identity TechInfoUnileverEditors | Set-EXLDistributionGroup -HiddenFromAddressListsEnabled:$True

# Office 365 Shared Group settings prior to migration
$a = gc C:\Temp\shared.txt
$a | % {get-adgroup -Identity $_ | Set-ADGroup -GroupScope Universal}
$a | % {Enable-EXLDistributionGroup -identity $_ }
$a | % {Get-EXLDistributionGroup -identity $_ | Set-EXLDistributionGroup -HiddenFromAddressListsEnabled:$True}

#Fix Default Calendar permissions
Add-EXLMailboxFolderPermission -Identity "RDNJ_GardenRm:\Calendar" -User "Calendar_Detail" -AccessRights LimitedDetails
Set-EXLMailboxFolderPermission -Identity "RDNJ_GardenRm:\Calendar" -User Default -AccessRights AvailabilityOnly

#Policy Checkbox is checked
Get-EXLMailbox -Filter * -ResultSize Unlimited | Select DisplayName, PrimarySMTPAddress, EmailAddressPolicyEnabled | Out-GridView

#Skype Rework IFF
$Users | % {get-aduser -Identity $_ -Properties DisplayName, Mail | Select DisplayName, Mail | Sort-Object DisplayName | Export-Csv c:\temp\license.csv -NoTypeInformation -Append}

$users | % {Get-MsolUser -UserPrincipalName $_ } | ? {($_.Licenses | Out-String) -notlike "*PACK*"} | % {Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -AddLicenses "IFF:STANDARDPACK"}

get-exohostedcontentfilterpolicy | Select -ExpandProperty AllowedSenders 

#DirSync Status
Get-MSOlUser -ALL | Select-Object UserPrincipalName, LastDirSyncTime, ValidationStatus, DirSyncProvisioningErrors | Out-GridView


#Conference Policies
Grant-CsConferencingPolicy -identity "Abigail Dolan" -PolicyName BposSAllModalityNoRec
get-csonlineuser | Select DisplayName, ConferencingPolicy | Out-GridView
get-csonlineuser | % {Grant-CsConferencingPolicy -PolicyName BposSAllModalityNoRec}

#Client Policies
Set-CsClientPolicy -Identity Global -EnableIMAutoArchiving $False -EnableCallLogAutoArchiving $False
Set-CsClientPolicy -Identity Global -DisableSavingIM $True

#Run retention policies/tags on a specific mailbox
Start-EXOManagedFolderAssistant -Identity rob.wolsky@iff.com


#find proxy addresses not in tenant
get-aduser -Filter * -Properties ProxyAddresses | Select -ExpandProperty ProxyAddresses | ? {($_ -notlike "*iff*") -and ($_ -notlike "*X500*") -and ($_ -notlike "*tastepoint*") -and ($_ -notlike "*powderpure*")}

#remove automapping of shared mailbox
Add-MailboxPermission -Identity johnsmith@contoso.onmicrosoft.com -User admin@contoso.onmicrosoft.com -AccessRights FullAccess -AutoMapping:$false

#clear MigraionBatchName from user 
Set-ADUser -Identity mxr9886 -Clear msExchMailboxMoveBatchName

#How Many OU's in Exchange?
Get-EXLOrganizationalUnit -ResultSize unlimited | Measure-Object

<# web.config setting for environments with more than 500 (default) OU's
    <add key="GetListDefaultResultSize" value="1500" /> 
  </appSettings>
#>

#check IP's in Receive connector
Get-EXLReceiveConnector -Identity "IFFANDFE01\SharePoint 2010 Outgoing Email" | select -expandproperty remoteipranges

#Check Max Send and Receive Sizes
Get-EXOTransportConfig | fl maxreceivesize,maxsendsize
Get-EXOMailboxPlan | fl name,maxsendsize,maxreceivesize,isdefault
Get-EXOMailbox -Resultsize Unlimited | Set-Mailbox -MaxReceiveSize 150MB -MaxSendSize 150MB
Get-EXOMailbox ROB.WOLSKY@IFF.COM | fl mailboxplan,maxsendsize,maxreceivesize

#Autodiscover Internal URI
Get-EXLClientAccessServer | Select Identity, AutoDiscoverServiceInternalUri, AutoDiscoverSiteScope

#Search Audit Log for Teams External MemberAdded
$a = Search-EXOUnifiedAuditLog -ResultSize 5000 -StartDate 4/1/2019 -EndDate 4/8/2019 -RecordType MicrosoftTeams -Operations MemberAdded -Formatted
$a.AuditData | Where {($_ | OUt-String) -like "*EXT*"} | ConvertFrom-Json | Select -Property UserId -ExpandProperty Members | FT UserId, DisplayName, Role, UPN

#Search Audit Log for Last Mailbox Access
$a = Search-EXOUnifiedAuditLog -ResultSize 100 -StartDate 4/7/2019 -EndDate 4/8/2019 -RecordType ExchangeItem -Operations MailboxLogin -Formatted
$a.AuditData | ConvertFrom-Json | Select -Property UserId, ResultStatus, CreationTime | FT UserId, ResultStatus, CreationTime

#Conference Room Delegates for Office 365
get-exomailbox RDNJDelegateTest | Set-EXOCalendarProcessing -AllBookInPolicy:$false -AllRequestInPolicy:$false -BookInPolicy "ITGlobal@iff.com", "Rob.Wolsky@iff.com"
get-exomailbox RDNJ_ConfRmC | Set-EXOCalendarProcessing -AllBookInPolicy:$false -AllRequestInPolicy:$false -BookInPolicy "ITGlobal@iff.com", "maryanne.elfstrom@iff.com", "danielle.cocuzza@iff.com", "fran.parkinson@iff.com", "veronica.cocuzza@iff.com", "maria.molloy@iff.com", "fara.alvarez@iff.com", "Deb.Kieselowsky@IFF.com", "Soumya.Thankam@IFF.com"
get-exomailbox RDNJ_ConfRmC | Set-EXOCalendarProcessing -AllBookInPolicy:$false -AllRequestInPolicy:$false -BookInPolicy "Patricia.Carney@iff.com", "Robert.Szpila@iff.com", "Heather.Doherty@IFF.com", "Drew.Riegler@iff.com", "Kishore.Gunturu@iff.com", "Rob.Wolsky@iff.com"

### Exlude Contact from Email Policy
Set-EXLMailContact -Identity "Anna Corless" -EmailAddressPolicyEnabled:$False

### Set Mailbox Quotas - Office 365
Set-EXOMailbox nanci.prado@iff.com -ProhibitSendQuota 45GB  -ProhibitSendReceiveQuota 50GB  -IssueWarningQuota 40GB
Get-EXOMailbox nanci.prado@iff.com | Select *quota

### Distribution List Creation from Topological Sort output
$dl = Import-Csv -Path C:\Temp\ValeryClaude.txt -Header CN, Full, Title
ForEach ($user in [Array] $dl)
{
  Add-EXLDistributionGroupMember -Identity "IFF_KCP_Claude_All" -Member $user.CN -Confirm:$False -BypassSecurityGroupManagerCheck -DomainController naazedcpv1
        }

### Call Quality Dashboard Exports
$serverData = Get-CQDData -Dimensions 'FirstTenantDataBuilding.First Network Name','SecondTenantDataBuilding.Second Network Name','AllStreams.Month Year' -Measures 'Measures.Total Stream Count','Measures.Avg Call Duration','Measures.Audio Poor Stream Count', 'Measures.Audio Poor Percentage', 'Measures.Audio Poor Call Percentage', 'Measures.AppSharing Poor Percentage','Measures.Video Poor Percentage','Measures.VBSS Poor Percentage','Measures.First Feedback Rating Poor Percentage','Measures.Second Feedback Rating Poor Percentage'  -OutPutType DataTable -MonthYear '2019-08' -IsServerPair 'Client : Server'        
$clientData = Get-CQDData -Dimensions 'FirstTenantDataBuilding.First Network Name','SecondTenantDataBuilding.Second Network Name','AllStreams.Month Year' -Measures 'Measures.Total Stream Count','Measures.Avg Call Duration','Measures.Audio Poor Stream Count', 'Measures.Audio Poor Percentage', 'Measures.Audio Poor Call Percentage', 'Measures.AppSharing Poor Percentage','Measures.Video Poor Percentage','Measures.VBSS Poor Percentage','Measures.First Feedback Rating Poor Percentage','Measures.Second Feedback Rating Poor Percentage'  -OutPutType DataTable -MonthYear '2019-08' -IsServerPair 'Client : Client'
$serverData = Get-CQDData -Dimensions 'FirstTenantDataBuilding.First Network Name','SecondTenantDataBuilding.Second Network Name','AllStreams.Month Year' -Measures 'Measures.Total Stream Count','Measures.Avg Call Duration','Measures.Audio Poor Stream Count', 'Measures.Audio Poor Percentage', 'Measures.Audio Poor Call Percentage', 'Measures.AppSharing Poor Percentage','Measures.Video Poor Percentage','Measures.VBSS Poor Percentage','Measures.First Feedback Rating Poor Percentage','Measures.Second Feedback Rating Poor Percentage'  -OutPutType DataTable -IsServerPair 'Client : Server'        
$clientData = Get-CQDData -Dimensions 'FirstTenantDataBuilding.First Network Name','SecondTenantDataBuilding.Second Network Name','AllStreams.Month Year' -Measures 'Measures.Total Stream Count','Measures.Avg Call Duration','Measures.Audio Poor Stream Count', 'Measures.Audio Poor Percentage', 'Measures.Audio Poor Call Percentage', 'Measures.AppSharing Poor Percentage','Measures.Video Poor Percentage','Measures.VBSS Poor Percentage','Measures.First Feedback Rating Poor Percentage','Measures.Second Feedback Rating Poor Percentage'  -OutPutType DataTable -IsServerPair 'Client : Client'
$serverData | Export-Csv c:\temp\cqdserver.csv -NoTypeInformation
$clientData | Export-Csv c:\temp\cqdclient.csv -NoTypeInformation



### Function to Synch Active Directory
function Sync-Azure {
Clear-Host
write-host "Performing Azure Sync..." -ForegroundColor green
$s = New-PSSession -ComputerName "USBODIRSAPPV1"
Invoke-Command -Session $s -ScriptBlock {Import-Module "c:\Program Files\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1"}
Invoke-Command -Session $s -ScriptBlock {Start-ADSyncSyncCycle -PolicyType Delta}
Remove-PSSession $s

}

### Enable Unified Messaging for User.
Enable-o365UMMailbox -Identity $email -UMMailboxPolicy "BT OCM UM Default Policy" -Extensions $telephone -PIN 1234 -SendWelcomeMail $false -PINExpired $true -whatif 

###Compliance Search Commands
# Need to run Remote Powershell Module in another window, cut and paste these commands
#Connect-EXOPSSession -UserPrincipalName rob.wolsky@iff.com
Connect-IPPSSession -UserPrincipalName rob.wolsky@iff.com

#Alternate for VSCode Window
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

# Commpliance Search Commands
New-ComplianceSearch -Name "Phishing_Bdelcarlo" -ExchangeLocation All -ContentMatchQuery "(From:b.delcarlo@chiesi.com) AND (Subject:'e-Payment Invoice Approved Chiesi TR')"
New-ComplianceSearch -Name "Phishing_Azabrodina" -ExchangeLocation All -ContentMatchQuery "(From:alexandra.zabrodina@iff.com) AND (Subject:'e-payment invoice approved')"
New-ComplianceSearch -Name "Phishing_Azabrodina" -ExchangeLocation All -ContentMatchQuery "Password- 4534"
Start-ComplianceSearch -Identity "Phishing_Bdelcarlo"
Start-ComplianceSearch -Identity "Password4534"
Get-ComplianceSearch "Phishing_Bdelcarlo" | Select-Object Items | FL
New-ComplianceSearchAction -SearchName "Phishing_maria2" -Purge -PurgeType HardDelete
Get-ComplianceSearchAction 

### Replication Services Health Check
Get-EXLMailboxServer | Test-EXLMRSHealth

### Restrict Mobile Access - options in PowerShell EXO
Get-EXOActiveSyncDeviceAccessRule | Select Name, AccessLevel
Get-EXOOrganizationConfig | Select EWS*
get-EXOCASMailbox rob.wolsky@iff.com

### SharePoint OneDrive for Deleted User
Set-SPOUser -Site https://iff-my.sharepoint.com/personal/nigel_martyn_iff_com -IsSiteCollectionAdmin $true -LoginName rob.wolsky@iff.com

### Mail Search from Microsoft
Start-EXOHistoricalSearch -SenderAddress marie-claude.gingras@lucasmeyercosmetics.com  -StartDate 08/20/2019 -enddate 08/23/2019 -ReportType MessageTracedetail -NotifyAddress rob.wolsky@iff.com -MessageID "<a8a1be0a649e49ccb1433df234b6d0e9@DM6PR19MB2812.namprd19.prod.outlook.com>" -ReportTitle reportMalicious_date_2019
Start-EXOHistoricalSearch -SenderAddress marie-claude.gingras@lucasmeyercosmetics.com  -StartDate 08/20/2019 -enddate 08/23/2019 -ReportType MessageTracedetail -NotifyAddress rob.wolsky@iff.com -MessageID "a8a1be0a649e49ccb1433df234b6d0e9@DM6PR19MB2812.namprd19.prod.outlook.com" -ReportTitle reportMalicious_date_2019_bis

### Mismatched mailbox GUID preventing migration completion
Get-RemoteMailbox <alias of cloud mailbox to move> | Format-List ExchangeGUID
Get-Mailbox usersabc | Format-list ExchangeGuid
Set-RemoteMailbox userabc -ExchangeGUID f37c610a-5228-4511-9d87-03e4929323ec  (Online MailboxGUID)


### Set up Polycom Rooms
#New-EXLMailbox -UserPrincipalName ESBE_Azul_Room@iff.com -Alias ESBE_Azul_Room -FirstName "ESBE" -LastName "Azul Room" -Name "ESBE Azul Room" -DomainController usbodcpv3 -OrganizationalUnit "OU=Rooms and Equipment,OU=Exchange,OU=iff,DC=global,DC=iff,DC=com " -Room -EnableRoomMailboxAccount $true -RoomMailboxPassword (ConvertTo-SecureString -String P0lycom11 -AsPlainText -Force)
New-EXLMailbox -UserPrincipalName ESBE_Azul_Room@iff.com -Alias ESBE_Azul_Room -FirstName "ESBE" -LastName "Azul Room" -Name "ESBE Azul Room" -DomainController usbodcpv3 -OrganizationalUnit "global.iff.com/IFF/Exchange/Rooms and Equipment" -Room -EnableRoomMailboxAccount $true -RoomMailboxPassword (ConvertTo-SecureString -String P0lycom11 -AsPlainText -Force)

### Skype Hybrid Properties - for Skype for Business Online - need rxw1401_e credentials
$user = get-aduser -Filter 'mail -like "CAQC_Mamad*"'
$credential = Get-Credential
Set-ADUser -Identity $user.samaccountname -Credential $credential -Add @{'msRTCSIP-DeploymentLocator'="sipfed.online.lync.com"}
Set-ADUser -Identity $user.samaccountname -Credential $credential -Add @{'msRTCSIP-FederationEnabled'=$TRUE}
Set-ADUser -Identity $user.samaccountname -Credential $credential -Add @{'msRTCSIP-InternetAccessEnabled'=$TRUE}
Set-ADUser -Identity $user.samaccountname -Credential $credential -Add @{'msRTCSIP-OptionFlags'=257}
Set-ADUser -Identity $user.samaccountname -Credential $credential -Add @{'msRTCSIP-PrimaryHomeServer'="CN=Lc Services,CN=Microsoft,CN=2:1,CN=Pools,CN=RTC Service,CN=Services,CN=Configuration,DC=global,DC=iff,DC=com"}
Set-ADUser -Identity $user.samaccountname -Credential $credential -Add @{'msRTCSIP-PrimaryUserAddress'="sip:" + $user.UserPrincipalName}
Set-ADUser -Identity $user.samaccountname -Credential $credential -Add @{'msRTCSIP-UserEnabled'=$TRUE}
Set-ADUser -Identity $user.samaccountname -Credential $credential -Add @{'msRTCSIP-UserPolicies'="{21=1, 1=3, 13=2}"}

Add-ADGroupMember -Identity "okta_all_iff_users_hr" -Members abc1234

$pool="sippoolBLU1A11.infra.lync.com"
Enable-CsMeetingRoom -Identity ESBE_Azul_Room@iff.com -RegistrarPool $pool -SipAddressType EmailAddress 

### Skype Hybrid Properties - for Skype for Business Online - need rxw1401_e credentials
$cred = Get-Credential
set-aduser abc1234 -Replace @{'msRTCSIP-DeploymentLocator'= "SRV:"} -Server usbodcpv3 -Credential $cred


### Vaya Pharma Inventory
get-enzmailbox -Filter 'WindowsEmailAddress -like "*@vayapharma.com"' | Select DisplayName, AccountDisabled, UserPrincipalName, LitigationHoldEnabled, WindowsEmail* | Out-Gridview

###Cobol disco stuff for John
Get-ADUser -Filter '(Enabled -eq $false) -And (msExchRecipientTypeDetails -eq "2147483648")' -Properties * | Select Name, iff* | Out-Gridview

get-exomailbox rob.wolsky@iff.com | Select * | FL

# Audit all Admin Role assignments in O365 Portal
Get-MsolRole | %{$role = $_.name; Get-MsolRoleMember -RoleObjectId $_.objectid} | select @{Name="Role"; Expression = {$role}}, DisplayName, EmailAddress | Export-Csv -Path "c:\temp\AdminRoles.csv"
