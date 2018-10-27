<# By Andrew Piskai
   anpiskai@microsoft.com
   8/28/2016
   revised: 4/24/2018

   This script is intended to be used as is to pull tenant settings from an Office 365 tenant. Any modifications or changes to the script are undertaken at the risk of the person running it. 

   Prerequisites:
   • Account Permissions
       • Office 365 Global Admin account with at least read permissions to all of the subservices of the Office 365 Suite including Exchange Online, SharePoint Online, Skype for Business Online and the Security and Compliance Center
   • PowerShell Modules
       • Windows Azure AD Powershell Module - https://msdn.microsoft.com/en-us/library/azure/jj151815(v=azure.98).aspx#bkmk_installmodule 
       • Exchange- Nothing to install
       • SPO- http://go.microsoft.com/fwlink/p/?LinkId=255251 
       • Skype- https://www.microsoft.com/en-us/download/details.aspx?id=39366
       • Security and Compliance Center -nothing to install

   Features intentionally not included:
   •	MSOL cmdlets not included
        o	Get-MSOLContact
        o	Get-MSOLDevice
        o   Get-MSOLDirSyncProvisioningError
        o   Get-MSOLDomainVerificationDns
        o   Get-MSOLFederationProperty
        o   Get-MSOLServicePrincipalCredential      
        o   Get-MSOLUser
        o   Get-MSOLUserByStrongAuthentication
        o   Get-MSOLUserRole
   •	EXO cmdlets not included
        o	Address Book cmdlets
            •	https://technet.microsoft.com/en-us/library/mt670894(v=exchg.160).aspx
            •	All cmdlets
        o	Anti-spam and anti-malware cmdlets in Exchange Online
            •	https://technet.microsoft.com/en-us/library/dn641229(v=exchg.160).aspx
            •	Advanced Threat Protection cmdlets
                •	Get-AdvancedThreatProtectionTrafficReport
                •	Get-SpoofMailReport
                •	Get-URLTrace
            •	Anti-Spam cmdlets
                •	Get-QuarantineMessage
                •	Get-QuarantineMessageHeader
            •	MailboxJunkEmailConfiguration cmdlets        
        o	Client Access Server cmdlets
            •	https://technet.microsoft.com/en-us/library/dn641223(v=exchg.160).aspx
            •	CASMailbox cmdlets
            •	OWA cmdlets with Get-Mailbox<word>Configuration format 
            •	Get-MobileDevice
            •	Get-MobileDeviceStatistics
            •	Get-ActiveSyncDevice
            •	Get-ActiveSyncMailboxPolicy (deprecated)
            •	Get-TextMessagingAccount
        o	Connected Accounts cmdlets
            •	https://technet.microsoft.com/en-us/library/dn641220(v=exchg.160).aspx
            •	All cmdlets
        o	Mailbox Cmdlets
            •	https://technet.microsoft.com/en-us/library/dn641230(v=exchg.160).aspx
            •	Mailbox cmdlets
            •	Mailbox configuration cmdlets
            •	Mailbox permission cmdlets
            •	Mailbox Folder Statistics cmdlets
            •	Calendar cmdlets
            •	Clutter cmdlets
            •	Focused Inbox cmdlets
            •	Inbox Rule cmdlets
            •	Sweep Rule cmdlets
            •	User Photo cmdlets
            •	Get-MessageCategory
        o	Move and Migration Cmdlets
            •	https://technet.microsoft.com/en-us/library/dn641236(v=exchg.160).aspx
            •	Mailbox Move cmdlets
            •	Get-MigrationBatch
            •	Get-MigrationStatistics
            •	Get-MigrationUser
            •	Get-MigrationUserStatistics
            •	Public folder migration cmdlets
        o	Policy and Compliance Cmdlets
            •	https://technet.microsoft.com/en-us/library/dn641228(v=exchg.160).aspx
            •	Get-AuditLogSearch
            •	Get-MailboxSearch
        o	Reporting Cmdlets
            •	https://technet.microsoft.com/en-us/library/dn641232(v=exchg.160).aspx
            •	All cmdlets
        o	Sharing and Collaboration Cmdlets
            •	https://technet.microsoft.com/en-us/library/dn641224(v=exchg.160).aspx
            •	Public Folder cmdlets
            •	Get-SiteMailbox
            •	Get-SiteMailboxDiagnostics
        o	Unified Messaging
            •	https://technet.microsoft.com/en-us/library/dn641235(v=exchg.160).aspx
            •	UM Call Answering cmdlets
            •	UM call data and summary report cmdlets
            •	UM Mailbox cmdlets
            •	UM Mailbox PIN cmdlets
            •	UM Prompt Management cmdlets
            •   Online Meeting Configuration
        o	Users and Groups cmdlets
            •	https://technet.microsoft.com/en-us/library/dn641234(v=exchg.160).aspx
            •	All cmdlets
   •	SPO Cmdlets Not included
        o	https://technet.microsoft.com/en-us/library/fp161364.aspx
        o	Get-SPOAppErrors
        o	Get-SPOAppInfo
        o	Get-SPODeletedSite
        o	Get-SPOTenantLogEntry
        o	Get-SPOTenantLogLastAvailableTimeInUTC   
        o   Get-SPOTenantCDNAllowedFileTypes
        o   Get-SPOTenantCDNOrigins
        o   Get-SPOTenantCDNPolicies
   •	Skype Cmdlets not included
        o	https://technet.microsoft.com/en-us/library/mt228132.aspx
        o   https://technet.microsoft.com/en-us/library/dn362817(v=ocs.15).aspx
        o   Group Search Cmdlets
        o   ONLINE AUDIO FILE Cmdlets
        o   ONLINE CARRIER PORTABILITY IN Cmdlets
        o   Get-CsOnlineDirectoryUser
        o   ONLINE SCHEDULE Cmdlets
        o   ONLINE TIME RANGE Cmdlets
        o   ONLINE USER Cmdlets
        o   ONLINE VOICE USER Cmdlets
        o   USER Cmdlets
        o   Get-CsEffectiveTenantDialPlan
        o   Get-CsOnlineDialInConferencingUser
        o   Get-CsOnlineEnhancedEmergencyServiceDisclaimer
        o   Get-CsOnlineNumberPortInOrder
        o   Get-CsOnlineTelephoneNumber
        o   Get-CsOnlineTelephoneNumberAvailableCount
        o   Get-CsOnlineTelphoneNumberInventoryAreas
        o   Get-CsOnlineTelphoneNumberInventoryCities
        o   Get-CsOnlineTelphoneNumberInventoryCountries
        o   Get-CsOnlineTelphoneNumberInventoryRegions
        o   Get-CsOnlineTelphoneNumberInventoryTypes
        o   Get-CsOnlineTelphoneNumberReservationInformation
        o   Get-CsOnlineUMMailbox
        o   Get-CsOnlineUMMailboxPolicy
   •	Security and Compliance Center cmdlets not included
        o	https://technet.microsoft.com/en-us/library/mt587093(v=exchg.160).aspx
        o	Get-ComplianceSearch
        o	Get-ComplianceSearchAction
        o	Get-CaseHoldPolicy
        o	Get-compliancecase
        o	Get-ComplianceCaseMember
        o	User and Group cmdlets
        o	Get-SupervisoryReviewReport
        o   Get-SupervisoryReviewPolicyReport
#>


Import-Module MSOnline
$msoCred = Get-Credential -Message "Please provide Global Administrator credentials for your tenant."
connect-msolservice –credential $msocred
start-transcript -path ".\tenantSettingsTranscript.txt" -append
(get-date).ToString()
$FormatEnumerationLimit=500

$SPOURL=Read-Host -Prompt "Please enter your Sharepoint Admin page URL (typically in the format: https://contoso-admin.sharepoint.com)"

$subfolders=dir
if($subfolders.Name -notcontains "Reports"){
    New-Item -Path .\Reports -ItemType Directory
}


#----------------------------------------------------------
#MSOLSettings
#----------------------------------------------------------
#region
#AccountSkus
Write-Host "Pulling information about Account SKUs..." -ForegroundColor Magenta
$skus=(Get-MsolAccountSku|select accountskuid,activeunits,consumedunits,suspendedUnits,skupartnumber)
$skus|Export-Csv .\Reports\O365AccountSkus.csv -NoTypeInformation

#AdministrativeUnits
Write-Host "Pulling information about Administrative Units..." -ForegroundColor Magenta
$aus=Get-MsolAdministrativeUnit
$aus|Export-Csv .\Reports\O365AdministrativeUnits.csv -NoTypeInformation

#AdministrativeUnitMembers
Write-Host "Pulling information about Administrative Unit Members..." -ForegroundColor Magenta
$aums=@()
foreach($au in $aus){
    $auID=$au.ObjectID
    $auName=$au.DisplayName
    foreach($aumember in (Get-MsolAdministrativeUnitMember -AdministrativeUnitObjectId $auID)){
        $aumembershipObject=[pscustomobject]@{AdministrativeUnitDisplayName="$auName";AdministrativeUnitObjectID="$auID";MemberDisplayName="$($aumember.DisplayName)";MemberEmailAddress="$($aumember.EmailAddress)";MemberObjectID="$($aumember.ObjectID)"}
        $aums+=$aumembershipObject
    }
}
$aums|Export-Csv .\Reports\O365AdministrativeUnitMemberships.csv -NoTypeInformation

#Company Allowed Data Location
Write-Host "Pulling information about Company Allowed Data Locations..." -ForegroundColor Magenta
$companyalloweddatalocation=Get-MsolCompanyAllowedDataLocation
$companyalloweddatalocation|Export-Csv .\Reports\O365CompanyAllowedDataLocations.csv -NoTypeInformation

#CompanyInformation
Write-Host "Pulling information about Company Information..." -ForegroundColor Magenta
$companyinfo=Get-MsolCompanyInformation
$companyinfo|Export-Csv .\Reports\O365CompanyInformation.csv -NoTypeInformation

#Device Registration Service Policy
Write-Host "Pulling information about Device Registration Service Policy..." -ForegroundColor Magenta
$deviceRegistrationServicePolicy=Get-MsolDeviceRegistrationServicePolicy
$deviceRegistrationServicePolicy|Export-Csv .\Reports\O365DeviceRegistrationServicePolicy.csv -NoTypeInformation

#DirSync Enablement
Write-Host "Pulling information about DirSyncEnablement..." -ForegroundColor Magenta
$DSConfig=Get-MsolDirSyncConfiguration
$DSConfig|Export-Csv .\Reports\O365DirSyncEnablement.csv -NoTypeInformation

#DirSync Features
Write-Host "Pulling information about DirSync Features..." -ForegroundColor Magenta
$DSFeatures=Get-MsolDirSyncFeatures
$DSFeatures|Export-Csv .\Reports\O365DirSyncFeatures.csv -NoTypeInformation

#Domains
Write-Host "Pulling information about Domains..." -ForegroundColor Magenta
$domains=Get-MsolDomain
($domains|select name,rootdomain,status,verificationmethod,capabilities,Authentication)|Export-Csv .\Reports\O365Domains.csv -NoTypeInformation

#DomainFederationSettings
Write-Host "Pulling information about Domain Federation Settings..." -ForegroundColor Magenta
$output=foreach($domain in $domains){if ($domain.Authentication -eq "Federated") {Get-MsolDomainFederationSettings -DomainName $domain.name}} 
$output|export-csv .\Reports\O365DomainFederationSettings.csv -NoTypeInformation

#Roles
Write-Host "Pulling information about O365 Roles..." -ForegroundColor Magenta
$o365roles=Get-MsolRole
$o365roles|export-csv .\Reports\O365Roles.csv -NoTypeInformation

#Role Membership
Write-Host "Pulling information about O365 Role Memberships..." -ForegroundColor Magenta
$roleMemberships=@()
foreach($role in $o365roles){
    $roleID=$role.objectID
    $roleName=$role.Name

    foreach($member in (get-msolrolemember -RoleObjectId $roleID)){
        $membershipObject=[pscustomobject]@{RoleName='';ServicePrincipalType='';EmailAddress='';DisplayName='';IsLicensed=''}
        $membershipObject.RoleName = $roleName
        $membershipObject.ServicePrincipalType=$member.ServicePrincipalType
        $membershipObject.EmailAddress = $member.EmailAddress
        $membershipObject.DisplayName = $member.DisplayName
        $membershipObject.IsLicensed = $member.IsLicensed
        $roleMemberships+=$membershipObject
    }
}
$roleMemberships|Export-Csv .\Reports\O365RoleMemberships.csv -NoTypeInformation

#ScopedRoleMember
Write-Host "Pulling information about Scoped O365 Role Memberships..." -ForegroundColor Magenta
$scopedroleMemberships=@()
foreach($role in $o365roles){
    $scopedroleID=$role.objectID
    $scopedroleName=$role.Name
    foreach($au in $aus){
        $scopedauID=$au.ObjectID
        $scopedauName=$au.DisplayName
        foreach($scopedmember in (Get-MsolScopedRoleMember -RoleObjectId $scopedroleID -AdministrativeUnitObjectId $scopedauID)){
            $scopedmembershipObject=[pscustomobject]@{ScopedAdministrativeUnitID='';ScopedAdministrativeUnitDisplayName='';ScopedRoleName='';ServicePrincipalType='';EmailAddress='';DisplayName='';IsLicensed=''}
            $scopedmembershipObject.ScopedAdministrativeUnitID = $scopedauID
            $scopedmembershipObject.ScopedAdministrativeUnitDisplayName = $scopedauName
            $scopedmembershipObject.ScopedRoleName = $scopedroleName
            $scopedmembershipObject.ServicePrincipalType=$scopedmember.ServicePrincipalType
            $scopedmembershipObject.EmailAddress = $scopedmember.EmailAddress
            $scopedmembershipObject.DisplayName = $scopedmember.DisplayName
            $scopedmembershipObject.IsLicensed = $scopedmember.IsLicensed           
            $scopedroleMemberships+=$scopedmembershipObject
        }
    }
}
$scopedroleMemberships|Export-Csv .\Reports\O365ScopedRoleMemberships.csv -NoTypeInformation


#Service Principal
Write-Host "Pulling information about Service Principals..." -ForegroundColor Magenta
$ServicePrincipalArray = @()
$serviceprincipals=Get-MsolServicePrincipal
foreach($serviceprincipal in $serviceprincipals){
    $tempServicePrincipal = [pscustomobject]@{DisplayName = "$($serviceprincipal.DisplayName)";ObjectID = "$($serviceprincipal.ObjectID)";AppPrincipalID = "$($serviceprincipal.AppPrincipalID)";AccountEnabled = "$($serviceprincipal.AccountEnabled)";TrustedForDelegation = "$($serviceprincipal.TrustedForDelegation)";Addresses = "$($serviceprincipal.Addresses.Address)";ServicePrincipalNames="$($serviceprincipal.ServicePrincipalNames)"}
    $ServicePrincipalArray+=$tempServicePrincipal
}
$ServicePrincipalArray|Export-Csv .\Reports\O365ServicePrincipals.csv -NoTypeInformation

#Subscription
Write-Host "Pulling information about O365 Subscriptions..." -ForegroundColor Magenta
$o365subs=Get-MsolSubscription
$o365subs|export-csv .\Reports\O365Subscriptions.csv -NoTypeInformation
#endregion

#----------------------------------------------------------
#Exchange Online Settings
#----------------------------------------------------------
#region
$EXOSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $msoCred -Authentication Basic -AllowRedirection 
Import-PSSession $EXOSession

#### ANTISPAM/ANTIMALWARE/
#region
#Advanced Threat Protection (ATP) cmdlets
#ATP Policies
Write-Host "Pulling information about ATP Policies..." -ForegroundColor Magenta
$atpp=(get-ATPPolicyForO365|select *)
$atpp|Export-Csv .\Reports\EXOATPPolicies.csv -NoTypeInformation
#Phish Filter Policies
Write-Host "Pulling information about Phish Filter Policies..." -ForegroundColor Magenta
$phishfilterpolicies=Get-PhishFilterPolicy -Detailed -SpoofAllowBlockList|select *
$phishfilterpolicies|Export-Csv .\Reports\EXOPhishFilterPolicies.csv -NoTypeInformation
#Safe Attachment Policies
Write-Host "Pulling information about Safe Attachment Policies..." -ForegroundColor Magenta
$safeAttachmentPolicies=Get-SafeAttachementPolicy|select *
$safeAttachmentPolicies|Export-Csv .\Reports\EXOSafeAttachmentPolicies.csv -NoTypeInformation
#Safe Attachment Rules
Write-Host "Pulling information about Safe Attachment Rules..." -ForegroundColor Magenta
$safeAttachmentRule=Get-SafeAttachmentRule|select *
$safeAttachmentRule|export-csv .\Reports\EXOSafeAttachmentRules.csv -NoTypeInformation
#Safe Links Policy
Write-Host "Pulling information about Safe Links Policies..." -ForegroundColor Magenta
$safeLinksPolicies=Get-SafeAttachmentRule|select *
$safeLinksPolicies|export-csv .\Reports\EXOSafeLinksPolicies.csv -NoTypeInformation
#Safe Links Rules
Write-Host "Pulling information about Safe Links Rules..." -ForegroundColor Magenta
$safeLinksRule=Get-SafeLinksRule|select *
$safeLinksRule|export-csv .\Reports\EXOSafeLinksRules.csv -NoTypeInformation
#endregion


#Malware Filter Policies
#region
Write-Host "Pulling information about Malware Filter Policies..." -ForegroundColor Magenta
$mfp=(get-malwarefilterpolicy|select *)
$mfp|Export-Csv .\Reports\EXOMalwareFilterPolicies.csv -NoTypeInformation
#Malware Filter Rules
Write-Host "Pulling information about Malware Filter Rules..." -ForegroundColor Magenta
$mfr=(get-malwarefilterrule|select *)
$mfr|Export-Csv .\Reports\EXOMalwareFilterRules.csv -NoTypeInformation
#Hosted Connection Filter Policies
Write-Host "Pulling information about Hosted Connection Filter Policies..." -ForegroundColor Magenta
$hcfp=Get-HostedConnectionFilterPolicy
$hcfp|Export-Csv .\Reports\EXOHostedConnectionFilterPolicies.csv -NoTypeInformation
#Hosted Content Filter Policies
Write-Host "Pulling information about Hosted Content Filter Policies..." -ForegroundColor Magenta
$hcfp2=Get-HostedContentFilterPolicy
$hcfp2|Export-Csv .\Reports\EXOHostedContentFilterPolicies.csv -NoTypeInformation
#HostedContentFilterRule
Write-Host "Pulling information about Hosted Content Filter Rules..." -ForegroundColor Magenta
$hcfRule=Get-HostedContentFilterRule|select *
$hcfRule|export-csv .\Reports\EXOHostedContentFilterRules.csv -NoTypeInformation
#Hosted Outbound Spam Filter Policy
Write-Host "Pulling information about Outbound Spam Filter Policies..." -ForegroundColor Magenta
$hosfp=Get-HostedOutboundSpamFilterPolicy
$hosfp|Export-Csv .\Reports\EXOHostedOutboundSpamFilterPolicies.csv -NoTypeInformation
#DomainKeys Identified Mail (DKIM)
Write-Host "Pulling information about DomainKeys Identified Mail (DKIM)..." -ForegroundColor Magenta
$dkim=(Get-DkimSigningConfig|select *)
$dkim|Export-Csv .\Reports\EXODKIMSigningConfig.csv -NoTypeInformation
#endregion


#### CLIENT ACCESS
#region
#Outlook Web App Policies
Write-Host "Pulling information about OWA Policies..." -ForegroundColor Magenta
$owapolicies=get-owaMailboxPolicy
$owapolicies|Export-Csv .\Reports\EXOOWAMailboxPolicies.csv -NoTypeInformation
#S/MIME config
Write-Host "Pulling information about S/MIME Config..." -ForegroundColor Magenta
$smimeconfig=Get-SmimeConfig
$smimeconfig|Export-Csv .\Reports\EXOSMimeConfig.csv -NoTypeInformation
#Mobile Device Mailbox Policies
Write-Host "Pulling information about Mobile Device Mailbox Policies..." -ForegroundColor Magenta
$mdmp=(get-MobileDeviceMailboxPolicy|select *)
$mdmp|Export-Csv .\Reports\EXOMobileDeviceMailboxPolicies.csv -NoTypeInformation
#ActiveSync Device Access Rules
Write-Host "Pulling information about ActiveSync Device Access Rules..." -ForegroundColor Magenta
$asdar=(Get-ActiveSyncDeviceAccessRule|select *)
$asdar|Export-Csv .\Reports\EXOActiveSyncDeviceAccessRules.csv -NoTypeInformation
#ActiveSync Device Classes
Write-Host "Pulling information about ActiveSync Device Classes..." -ForegroundColor Magenta
$asdc=(Get-ActiveSyncDeviceClass|select *)
$asdc|Export-Csv .\Reports\EXOActiveSyncDeviceClass.csv -NoTypeInformation
#ActiveSync Organization Settings
Write-Host "Pulling information about ActiveSync Organization Settings..." -ForegroundColor Magenta
$asos=get-ActiveSyncOrganizationSettings
$asos|Export-Csv .\Reports\EXOActiveSyncOrganizationSettings.csv -NoTypeInformation
#endregion


#### EMAIL ADDRESS POLICY
#region
Write-Host "Pulling information about Email Address Policies..." -ForegroundColor Magenta
$EmailAddressPolicy=Get-EmailAddressPolicy|select *
$EmailAddressPolicy|export-csv .\Reports\EXOEmailAddressPolicies.csv -NoTypeInformation
#endregion


#### FEDERATION AND HYBRID
#region
#Federated Organization Identifiers
Write-Host "Pulling information about Federated Organization Identifiers ..." -ForegroundColor Magenta
$fio=(Get-FederatedOrganizationIdentifier|select *)
$fio|Export-Csv .\Reports\EXOFederatedOrganizationIdentifier.csv -NoTypeInformation
#Federation Information
Write-Host "Pulling information about Federation..." -ForegroundColor Magenta
$fi=@()
$domains=Get-MsolDomain
$dnames = $domains.name
foreach($d in $dnames){
    $fedinfo=Get-FederationInformation -domainName $d -force
    $fedinfoobj=[pscustomobject]@{DomainName='';TargetApplicationURI='';TargetAutodiscoverEpr='';TokenIssuerURIs='';IsValid='';ObjectState=''}
    $fedinfoobj.DomainName = $d
    $fedinfoobj.TargetApplicationURI=$fedinfo.TargetApplicationURI
    $fedinfoobj.TargetAutodiscoverEpr = $fedinfo.TargetAutodiscoverEpr
    $fedinfoobj.TokenIssuerURIs = $fedinfo.TokenIssuerURIs
    $fedinfoobj.Isvalid = $fedinfo.IsValid
    $fedinfoobj.ObjectState = $fedinfo.ObjectState
    $fi+=$fedinfoobj
}
$fi|export-csv .\Reports\EXOFederationInformation.csv -NoTypeInformation
#Federation Trusts
Write-Host "Pulling information about Federation Trusts..." -ForegroundColor Magenta
$ft=(Get-FederationTrust|select *)
$ft|export-csv .\Reports\EXOFederationTrusts.csv -NoTypeInformation
#Hybrid Mail Flow
Write-Host "Pulling information about Hybrid Mail Flow..." -ForegroundColor Magenta
$hmf=Get-HybridMailflow
$hmf|Export-Csv .\Reports\EXOHybridMailFlow.csv -NoTypeInformation
#Hybrid Mail Flow Datacenter IPs
Write-Host "Pulling information about Hybrid Mail Flow Datacenter IPs..." -ForegroundColor Magenta
$hmfdcips=Get-HybridMailflowDatacenterIPs
$hmfdcips|export-csv .\Reports\EXOHybridMailflowDatacenterIPs.csv -NoTypeInformation
#On-Premises Organization
Write-Host "Pulling information about on-premises organization..." -ForegroundColor Magenta
$opo=Get-OnPremisesOrganization
$opo|Export-Csv .\Reports\EXOOnPremisesOrganization.csv -NoTypeInformation
#IntraOrganizationConnector
Write-Host "Pulling information about IntraOrganization Connectors..." -ForegroundColor Magenta
$ioc=Get-IntraOrganizationConnector
$ioc|Export-Csv .\Reports\EXOIntraOrganizationConnector.csv -NoTypeInformation
#endregion


#### MAIL FLOW
#region
#Transport Config
Write-Host "Pulling information about Transport Config..." -ForegroundColor Magenta
$tc=Get-TransportConfig
$tc|Export-Csv .\Reports\EXOTransportConfig.csv -NoTypeInformation
#Inbound Connectors
Write-Host "Pulling information about Inbound Connectors..." -ForegroundColor Magenta
$ic=Get-InboundConnector|select *
$ic|Export-Csv .\Reports\EXOInboundConnectors.csv -NoTypeInformation
#Outbound Connectors
Write-Host "Pulling information about Outbound Connectors..." -ForegroundColor Magenta
$oc=Get-OutboundConnector|select *
$oc|Export-Csv .\Reports\EXOOutboundConnectors.csv -NoTypeInformation
#Accepted Domains
Write-Host "Pulling information about Accepted Domains..." -ForegroundColor Magenta
$ad=Get-AcceptedDomain|select *
$ad|Export-Csv .\Reports\EXOAcceptedDomains.csv -NoTypeInformation
#Remote Domains
Write-Host "Pulling information about Remote Domains..." -ForegroundColor Magenta
$rd=Get-RemoteDomain|select *
$rd|Export-Csv .\Reports\EXORemoteDomains.csv -NoTypeInformation
#endregion


#### MAILBOX
#region
#Mailbox Plans
Write-Host "Pulling information about Mailbox Plans..." -ForegroundColor Magenta
$mp=(Get-MailboxPlan|select *)
$mp|Export-Csv .\Reports\EXOMailboxPlans.csv -NoTypeInformation
#Apps for Outlook
Write-Host "Pulling information about Apps For Outlook..." -ForegroundColor Magenta
$apps=Get-App
$apps|Export-Csv .\Reports\EXOAppsForOutlook.csv -NoTypeInformation
#Inbox Rules
Write-Host "Pulling information about Inbox Rules..." -ForegroundColor Magenta
$ir=(Get-InboxRule|select *)
$ir|Export-Csv .\Reports\EXOInboxRules.csv -NoTypeInformation
#Search Document Format
Write-Host "Pulling information about Search Document Format..." -ForegroundColor Magenta
$sdf=Get-SearchDocumentFormat
$sdf|Export-Csv .\Reports\EXOSearchDocumentFormat.csv -NoTypeInformation
#endregion


#### MOVE AND MIGRATION
#region
#Migration Config
Write-Host "Pulling information about Migration Config..." -ForegroundColor Magenta
$mc=(Get-MigrationConfig|select *)
$mc|Export-Csv .\Reports\EXOMigrationConfig.csv -NoTypeInformation
#Migration Endpoints
Write-Host "Pulling information about Migration Endpoints..." -ForegroundColor Magenta
$me=(Get-MigrationEndpoint|select *)
$me|Export-Csv .\Reports\EXOMigrationEndpoints.csv -NoTypeInformation
#endregion


#### ORGANIZATION
#region
#CASMailboxPlan
Write-Host "Pulling information about CAS Mailbox Plans..." -ForegroundColor Magenta
$casmbxplans=Get-CASMailboxPlan|select *
$casmbxplans|Export-Csv .\Reports\EXOCASMailboxPlans.csv -NoTypeInformation

#Organizational Units
Write-Host "Pulling information about Organizational Units..." -ForegroundColor Magenta
$ou=Get-OrganizationalUnit
$ou|Export-Csv .\Reports\EXOOrganizationalUnits.csv -NoTypeInformation
#Organization Config
Write-Host "Pulling information about Organization Config..." -ForegroundColor Magenta
$orgConfig=Get-OrganizationConfig
$orgConfig|Export-Csv .\Reports\EXOOrganizationConfig.csv -NoTypeInformation
#Perimeter Config
Write-Host "Pulling information about Perimeter Config..." -ForegroundColor Magenta
$perimeterConfig=(Get-PerimeterConfig|select *)
$perimeterConfig|Export-Csv .\Reports\EXOPerimeterConfig.csv -NoTypeInformation
#endregion


#### POLICY AND COMPLIANCE
#region
#Admin Audit Log Config
Write-Host "Pulling information about Admin Audit Log Config..." -ForegroundColor Magenta
$aalc=Get-AdminAuditLogConfig
$aalc|Export-Csv .\Reports\EXOAdminAuditLogConfig.csv -NoTypeInformation
#Mailbox Audit Bypass Associations
Write-Host "Pulling information about Mailbox Audit Bypass Associations..." -ForegroundColor Magenta
$aaba=Get-MailboxAuditBypassAssociation
$aaba|Export-Csv .\Reports\EXOMailboxAuditBypassAssociation.csv -NoTypeInformation
#Data Encryption Policy
Write-Host "Pulling information about Data Encryption Policy..." -ForegroundColor Magenta
$dataep=Get-DataEncryptionPolicy|select *
$dataep|Export-Csv .\Reports\EXODataEncryptionPolicy.csv -NoTypeInformation
#Classification Rule Collections
Write-Host "Pulling information about Classification Rule Collections..." -ForegroundColor Magenta
$crc=Get-ClassificationRuleCollection
$crc|Export-Csv .\Reports\EXOClassificationRuleCollections.csv -NoTypeInformation
#Data Classifications
Write-Host "Pulling information about Data Classifications..." -ForegroundColor Magenta
$dc=Get-DataClassification
$dc|Export-Csv .\Reports\EXODataClassifications.csv -NoTypeInformation
#Data Classification Config
Write-Host "Pulling information about Data Classification Config..." -ForegroundColor Magenta
$dcc=Get-DataClassificationConfig
$dcc|Export-Csv .\Reports\EXODataClassificationConfig.csv -NoTypeInformation
#DLP Policies
Write-Host "Pulling information about DLP Policies ..." -ForegroundColor Magenta
$dlpp=(Get-DLPPolicy|select *)
$dlpp|Export-Csv .\Reports\EXODLPPolicies.csv -NoTypeInformation
#DLP Policy Templates
Write-Host "Pulling information about DLP Policy Templates..." -ForegroundColor Magenta
$dlppt=(Get-DLPPolicyTemplate|select *)
$dlppt|Export-Csv .\Reports\EXODLPPolicyTemplates.csv -NoTypeInformation
#Policy Tip Config
Write-Host "Pulling information about Policy Tip Config..." -ForegroundColor Magenta
$ptc=Get-PolicyTipConfig
$ptc|Export-Csv .\Reports\EXOPolicyTipConfig.csv -NoTypeInformation
#Transport Rules
Write-Host "Pulling information about Transport Rules..." -ForegroundColor Magenta
$tr=(Get-TransportRule|select *)
$tr|Export-Csv .\Reports\EXOTransportRules.csv -NoTypeInformation
#Transport Rule Actions
Write-Host "Pulling information about Transport Rule Actions..." -ForegroundColor Magenta
$tra=(Get-TransportRuleAction|select *)
$tra|Export-Csv .\Reports\EXOTransportRuleActions.csv -NoTypeInformation
#Transport Rule Predicates
Write-Host "Pulling information about Transport Rule Predicates..." -ForegroundColor Magenta
$trp=(Get-TransportRulePredicate|select *)
$trp|Export-Csv .\Reports\EXOTransportRulePredicates.csv -NoTypeInformation
#IRM Configuration
Write-Host "Pulling information about IRM Configuration..." -ForegroundColor Magenta
$irmc=Get-IRMConfiguration
$irmc|Export-Csv .\Reports\EXOIRMConfiguration.csv -NoTypeInformation
#Outlook Protection Rules
Write-Host "Pulling information about Outlook Protection Rules..." -ForegroundColor Magenta
$opr=(Get-OutlookProtectionRule|select *)
$opr|Export-Csv .\Reports\EXOOutlookProtectionRules.csv -NoTypeInformation
#RMS Templates
Write-Host "Pulling information about RMS Templates..." -ForegroundColor Magenta
$rmst=(Get-RMSTemplate|select *)
$rmst|Export-Csv .\Reports\EXORMSTemplates.csv -NoTypeInformation
#RMS Trusted Publishing Domains
Write-Host "Pulling information about RMS Trusted Publishing Domains..." -ForegroundColor Magenta
$rmstpd=Get-RMSTrustedPublishingDomain
$rmstpd|Export-csv .\Reports\EXORMSTrustedPublishingDomain.csv -NoTypeInformation
#Journal Rules
Write-Host "Pulling information about Journal Rules..." -ForegroundColor Magenta
$jr=(Get-JournalRule|select *)
$jr|Export-Csv .\Reports\EXOJournalRules.csv -NoTypeInformation
#Message Classifications
Write-Host "Pulling information about Message Classifications..." -ForegroundColor Magenta
$mc=(Get-MessageClassification|select *)
$mc|export-csv .\Reports\EXOMessageClassifications.csv -NoTypeInformation
#Retention Policies
Write-Host "Pulling information about Retention Policies..." -ForegroundColor Magenta
$rp=(Get-RetentionPolicy|select *)
$rp|Export-Csv .\Reports\EXORetentionPolicies.csv -NoTypeInformation
#Retention Policy Tags
Write-Host "Pulling information about Retention Policy Tags..." -ForegroundColor Magenta
$rpt=(Get-RetentionPolicyTag|select *)
$rpt|Export-Csv .\Reports\EXORetentionPolicyTags.csv -NoTypeInformation
#Office 365 Message Encryption
Write-Host "Pulling information about Office 365 Message Encryption..." -ForegroundColor Magenta
$omec=Get-OMEConfiguration
$omec|Export-Csv .\Reports\EXOOMEConfiguration.csv -NoTypeInformation
#endregion


#### SECURITY AND PERMISSIONS
#region
#Management Roles
Write-Host "Pulling information about Management Roles..." -ForegroundColor Magenta
$mr=(Get-ManagementRole|select *)
$mr|export-csv .\Reports\EXOManagementRoles.csv -NoTypeInformation
#Management Role Assignments
Write-Host "Pulling information about Management Role Assignments..." -ForegroundColor Magenta
$mra=Get-ManagementRoleAssignment
$mra|Export-Csv .\Reports\EXOManagementRoleAssignments.csv -NoTypeInformation
#Role Assignment Policies
Write-Host "Pulling information about Role Assignment Policies..." -ForegroundColor Magenta
$rap=(Get-RoleAssignmentPolicy|select *)
$rap|Export-Csv .\Reports\EXORoleAssignmentPolicies.csv -NoTypeInformation
#Management Role Entries
Write-Host "Pulling information about Management Role Entries..." -ForegroundColor Magenta
$roleentries=@()
foreach($role in $mr){
    $mre=Get-ManagementRoleEntry -Identity "$($role.name)\*"
    foreach($entry in $mre){
        $customEntry=[pscustomobject]@{Name='';Role=''}
        $customEntry.Name = $entry.name
        $customEntry.Role = $entry.role
        $roleentries+=$customEntry
    }
}
$roleentries|Export-Csv .\Reports\EXOManagementRoleEntries.csv -NoTypeInformation
#Role Groups
Write-Host "Pulling information about Role Groups..." -ForegroundColor Magenta
$rg=Get-RoleGroup
$rg|Export-Csv .\Reports\EXORoleGroups.csv -NoTypeInformation
#Role Group Members
Write-Host "Pulling information about Role Group Members..." -ForegroundColor Magenta
$roleGroupMembers=@()
foreach($roleGroup in $rg){
    $rgm=Get-RoleGroupMember -Identity $roleGroup.name
    foreach($member in $rgm){
        $customMember=[pscustomobject]@{RoleGroup='';Name='';RecipientType='';PrimarySMTPAddress=''}
        $customMember.RoleGroup = $roleGroup.name
        $customMember.Name = $member.Name
        $customMember.RecipientType = $member.RecipientType
        $customMember.PrimarySMTPAddress = $member.PrimarySMTPAddress
        $roleGroupMembers+=$customMember
    }
}
$roleGroupMembers|Export-Csv .\Reports\EXORoleGroupMembers.csv -NoTypeInformation
#Management Scopes
Write-Host "Pulling information about Management Scopes..." -ForegroundColor Magenta
$ms=(Get-ManagementScope|select *)
$ms|Export-Csv .\Reports\EXOManagementScopes.csv -NoTypeInformation
#Auth Servers
Write-Host "Pulling information about Auth Servers..." -ForegroundColor Magenta
$as=Get-AuthServer
$as|Export-Csv .\Reports\EXOAuthServers.csv -NoTypeInformation
#Partner Applications
Write-Host "Pulling information about Partner Applications..." -ForegroundColor Magenta
$pa=(Get-PartnerApplication|select *)
$pa|Export-Csv .\Reports\EXOPartnerApplications.csv -NoTypeInformation
#endregion


#### SHARING AND COLLABORATION
#region
#Availability Address Spaces
Write-Host "Pulling information about Availability Address Spaces..." -ForegroundColor Magenta
$aas=(Get-AvailabilityAddressSpace|select *)
$aas|Export-Csv .\Reports\EXOAvailabilityAddressSpaces.csv -NoTypeInformation
#Availability Config
Write-Host "Pulling information about Availability Config..." -ForegroundColor Magenta
$ac=(get-AvailabilityConfig|select *)
$ac|Export-Csv .\Reports\EXOAvailabilityConfig.csv -NoTypeInformation
#Organization Relationships
Write-Host "Pulling information about Organization Relationships..." -ForegroundColor Magenta
$orgRel=(Get-OrganizationRelationship|select *)
$orgRel|Export-Csv .\Reports\EXOOrganizationRelationships.csv -NoTypeInformation
#Sharing Policies
Write-Host "Pulling information about Sharing Policies..." -ForegroundColor Magenta
$sp=(Get-SharingPolicy|select *)
$sp|Export-Csv .\Reports\EXOSharingPolicy.csv -NoTypeInformation
#Site Mailbox Provisioning Policies
Write-Host "Pulling information about Site Mailbox Provisioning Policies..." -ForegroundColor Magenta
$smpp=(Get-SiteMailboxProvisioningPolicy|select *)
$smpp|Export-Csv .\Reports\EXOSiteMailboxProvisioningPolicies.csv -NoTypeInformation
#endregion


#### UNIFIED MESSAGING
#region
#UM AutoAttendants
Write-Host "Pulling information about UM AutoAttendants..." -ForegroundColor Magenta
$umaa=(Get-UMAutoAttendant|select *)
$umaa|Export-Csv .\Reports\EXOUMAutoAttendants.csv -NoTypeInformation
#UM Dial Plans
Write-Host "Pulling information about UM Dial Plans..." -ForegroundColor Magenta
$umdp=(Get-UMDialPlan|select *)
$umdp|Export-Csv .\Reports\EXOUMDialPlans.csv -NoTypeInformation
#UM Hunt Groups
Write-Host "Pulling information about UM Hunt Groups..." -ForegroundColor Magenta
$umhg=(Get-UMHuntGroup|select *)
$umhg|Export-Csv .\Reports\EXOUMHuntGroups.csv -NoTypeInformation
#UM IP Gateways
Write-Host "Pulling information about UM IP Gateways..." -ForegroundColor Magenta
$umipg=(Get-UMIPGateway|select *)
$umipg|Export-Csv .\Reports\EXOUMIPGateways.csv -NoTypeInformation
#UM Mailbox Policies
Write-Host "Pulling information about UM Mailbox Policies..." -ForegroundColor Magenta
$ummbxpol=(Get-UMMailboxPolicy|select *)
$ummbxpol|Export-Csv .\Reports\EXOUMMailboxPolicies.csv -NoTypeInformation
#endregion

Remove-PSSession $EXOSession 
#endregion

#----------------------------------------------------------
#SharePoint Online
#----------------------------------------------------------
#region
Connect-SPOService -Url $SPOURL -Credential $msoCred

#SPO External Users
Write-Host "Pulling information about SPO External Users..." -ForegroundColor Magenta
$spoexu=Get-SPOExternalUser
$spoexu|Export-Csv .\Reports\SPOExternalUsers.csv -NoTypeInformation
#SPO Sites
Write-Host "Pulling information about SPO Sites..." -ForegroundColor Magenta
$spos=Get-SPOSite -Limit All |select *
$spos|Export-Csv .\Reports\SPOSites.csv -NoTypeInformation
#SPO Site Data Encryption Policy
Write-Host "Pulling information about SPO Site Data Encryption Policies..." -ForegroundColor Magenta
$SPODEParray=@()
foreach($sposite in $spos){
    $tempSpoSiteDEP=Get-SPOSiteDataEncryptionPolicy -URL $sposite.URL -ErrorAction SilentlyContinue|select *
    $SPODEParray+=$tempSpoSiteDEP
}
if($SPODEParray){
    $SPODEParray|export-csv .\SPOSiteDataEncryptionPolicy -NoTypeInformation
}
#SPO Site Groups
Write-Host "Pulling information about SPO Site Groups..." -ForegroundColor Magenta
$sitesandgroups=@()
foreach($sposite in (Get-SPOSite).URL){
    $sposite
    $spositeg=Get-SPOSiteGroup -Site $sposite
    foreach($g in $spositeg){
        $spositegroup=[pscustomobject]@{URL='';LoginName='';Title='';OwnerLoginName='';OwnerTitle='';Users='';Roles=''}
        $spositegroup.URL = $sposite
        $spositegroup.LoginName=$g.LoginName
        $spositegroup.Title=$g.Title
        $spositegroup.OwnerLoginName=$g.OwnerLoginName
        $userlist = ""        
        foreach($item in $g.Users){
            $userlist+="$item;"
        }
        $spositegroup.Users=$userlist
        $rolelist = ""
        foreach($role in $g.roles){
            $rolelist+="$role;"
        }
        $spositegroup.Roles=$rolelist
        $sitesandgroups+=$spositegroup
    }
} 
$sitesandgroups| Export-Csv .\Reports\SPOSiteUserGroups.csv -NoTypeInformation 
#SPO Tenant Settings
Write-Host "Pulling information about SPO Tenant Settings..." -ForegroundColor Magenta
$spotenant=Get-SPOTenant
$spotenant|Export-Csv .\Reports\SPOTenantSettings.csv -NoTypeInformation 
#Get-SPOTenantCDNEnabled
Write-Host "Pulling information about SPO CDN Enablement" -ForegroundColor Magenta
$spoPublicCDNEnabled=[pscustomobject]@{CdnType='Public';Enabled="$((get-SPOTenantCdnEnabled -CdnType Public).value)"}
$spoPrivateCDNEnabled=[pscustomobject]@{CdnType='Private';Enabled="$((get-SPOTenantCdnEnabled -CdnType Private).value)"}
$spoCDNEnabledAggregate = @()
$spoCDNEnabledAggregate += $spoPublicCDNEnabled
$spoCDNEnabledAggregate += $spoPrivateCDNEnabled
$spoCDNEnabledAggregate|export-csv .\Reports\SPOCDNEnabled.csv -NoTypeInformation


#SPO Tenant Sync Client Restrictions
Write-Host "Pulling information about SPO Tenant Sync Client Restrictions..." -ForegroundColor Magenta
$spotscrestrictions=Get-SPOTenantSyncClientRestriction
$domainsallowed=""
foreach($dom in $spotscrestrictions.AllowedDomainList){
    $domainsallowed+="$dom "
}
#$domainsallowed
$fileextensions=""
foreach($fileext in $spotscrestrictions.ExcludedFileExtensions){
    $fileextensions+="$fileext "
}
#$fileextensions
$spotscrrevised=[pscustomobject]@{TenantRestrictionEnabled='';AllowedDomainList='';BlockMacSync='';ExcludedFileExtensions='';OptOutOfGrooveBlock='';OptOutOfGrooveSoftBlock=''}
$spotscrrevised.TenantRestrictionEnabled = $spotscrestrictions.TenantRestrictionEnabled
$spotscrrevised.AllowedDomainList = "$domainsallowed"
$spotscrrevised.BlockMacSync = $spotscrestrictions.BlockMacSync
$spotscrrevised.ExcludedFileExtensions = "$fileextensions"
$spotscrrevised.OptOutOfGrooveBlock = $spotscrestrictions.OptOutOfGrooveBlock
$spotscrrevised.OptOutOfGrooveSoftBlock = $spotscrestrictions.OptOutOfGrooveSoftBlock
$spotscrrevised|Export-Csv .\Reports\SPOTenantSyncClientRestrictions.csv -NoTypeInformation
#SPO Users 
Write-Host "Pulling information about SPO Users..." -ForegroundColor Magenta
$sitesandusers=@()
foreach($sposite in (Get-SPOSite).URL){
    $spositeu=Get-SPOUser -Site $sposite
    $sposite
    foreach($u in $spositeu){
        $spositeuser=[pscustomobject]@{URL='';DisplayName='';LoginName='';IsSiteAdmin='';IsGroup='';Groups=''}
        $spositeuser.URL = $sposite
        $spositeuser.DisplayName=$u.DisplayName
        $spositeuser.LoginName=$u.LoginName
        $spositeuser.IsSiteAdmin=$u.IsSiteAdmin
        $spositeuser.IsGroup=$u.IsGroup
        $groops=""
        foreach($groop in $u.Groups){
            $groops+="$groop; "
        }
        $spositeuser.Groups=$groops
        $sitesandusers+=$spositeuser
    }
}
$sitesandusers|Export-Csv .\Reports\SPOSiteUsers.csv -NoTypeInformation
#SPO Web Templates
Write-Host "Pulling information about SPO Web Templates..." -ForegroundColor Magenta
$spowt=Get-SPOWebTemplate
$spowt|Export-Csv .\Reports\SPOWebTemplates.csv -NoTypeInformation
#endregion

#----------------------------------------------------------
#Security and Compliance Center
#----------------------------------------------------------
#region
$SecurityAndComplianceSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $msocred -Authentication Basic -AllowRedirection
Import-PSSession $SecurityAndComplianceSession

#### AUDITING
#Activity Alerts
Write-Host "Pulling information about Activity Alerts..." -ForegroundColor Magenta
$aa=(Get-ActivityAlert|select *)
$aa|Export-Csv .\Reports\SandCActivityAlerts.csv -NoTypeInformation

#### CONTENT SEARCH
#Compliance Security Filter
Write-Host "Pulling information about Compliance Security Filters..." -ForegroundColor Magenta
$csf=(Get-ComplianceSecurityFilter|select *)
$csf|Export-Csv .\Reports\SandCComplianceSecurityFilter.csv -NoTypeInformation

#### DATA LOSS PREVENTION
#Compliance Policies
Write-Host "Pulling information about Compliance Policies..." -ForegroundColor Magenta
$dlpcp=(Get-DLPCompliancePolicy|select *)
$dlpcp|Export-Csv .\Reports\SandCDLPCompliancePolicies.csv -NoTypeInformation
#Compliance Rules
Write-Host "Pulling information about Compliance Rules..." -ForegroundColor Magenta
$dlpcr=(Get-DLPComplianceRule|select *)
$dlpcr|Export-Csv .\Reports\SandCDLPComplianceRules.csv -NoTypeInformation
#Sensitive information types
Write-Host "Pulling information about Sensitive Information Types..." -ForegroundColor Magenta
$dlpsit=(Get-DLPSensitiveInformationType|select *)
$dlpsit|Export-Csv .\Reports\SandCDLPSensitiveInformationTypes.csv -NoTypeInformation
#Sensitive Information Type Rule Package
Write-Host "Pulling information about Sensitive Information Type Rule Packages..." -ForegroundColor Magenta
$dlpsitpackage=(Get-DLPSensitiveInformationTypeRulePackage|select *)
$dlpsitpackage|Export-Csv .\Reports\SandCDLPSensitiveInformationTypeRulePackages.csv -NoTypeInformation

#### EDISCOVERY CASES
#Case Hold Rules
Write-Host "Pulling information about Case Hold Rules..." -ForegroundColor Magenta
$chr=(Get-CaseHoldRule|select *)
$chr|Export-Csv .\Reports\SandCCaseHoldRules.csv -NoTypeInformation
#eDiscovery Case Admins
Write-Host "Pulling information about eDiscovery Case Admins..." -ForegroundColor Magenta
$ediscca=Get-eDiscoveryCaseAdmin
$ediscca|Export-Csv .\Reports\SandCeDiscoveryCaseSAdmins.csv -NoTypeInformation

#### RETENTION POLICIES
#Get-ComplianceTag
Write-Host "Pulling information about Compliance Tags..." -ForegroundColor Magenta
$comptag=Get-ComplianceTag|select *
$comptag|Export-Csv .\Reports\SandCComplianceTags.csv -NoTypeInformation
#Get-ComplianceTagStorage
Write-Host "Pulling information about Compliance Tag Storage..." -ForegroundColor Magenta
$comptagstor=Get-ComplianceTagStorage|select *
$comptagstor|Export-Csv .\Reports\SandCComplianceTagStorage.csv -NoTypeInformation
#Retention Compliance Policies
Write-Host "Pulling information about Retention Compliance Policies..." -ForegroundColor Magenta
$rcp=(Get-RetentionCompliancePolicy|select *)
$rcp|Export-Csv .\Reports\SandCRetentionCompliancePolicy.csv -NoTypeInformation
#Retention Compliance Rules
Write-Host "Pulling information about Retention Compliance Rules..." -ForegroundColor Magenta
$rcr=(Get-RetentionComplianceRule|select *)
$rcr|Export-Csv .\Reports\SandCRetentionComplianceRule.csv -NoTypeInformation

#### SECURITY AND PERMISSIONS
#Management Roles
Write-Host "Pulling information about Management Roles..." -ForegroundColor Magenta
$mr=(Get-ManagementRole|select *)
$mr|Export-Csv .\Reports\SandCManagementRole.csv -NoTypeInformation
#Role Groups
Write-Host "Pulling information about Role Groups..." -ForegroundColor Magenta
$rg=(Get-RoleGroup|select *)
$rg|Export-csv .\Reports\SandCRoleGroups.csv -NoTypeInformation
#Role Group Members
Write-Host "Pulling information about Role Group Members..." -ForegroundColor Magenta
$rgandmember=@()
foreach($rolegroup in $rg.name){
    $rgm=Get-RoleGroupMember -Identity $rolegroup    
    foreach($member in $rgm){
        $rgmentry = [pscustomobject]@{roleGroup='';Name='';RecipientType=''}
        $rgmentry.roleGroup = $rolegroup
        $rgmentry.Name = $member.Name
        $rgmentry.RecipientType = $member.RecipientType
        $rgandmember+=$rgmentry
    }
}
$rgandmember|Export-Csv .\Reports\SandCRoleGroupMembers.csv -NoTypeInformation

#### SUPERVISION
Write-Host "Pulling information about Supervisory Review Policies..." -ForegroundColor Magenta
$supervisoryRevPol=Get-SupervisoryReviewPolicyV2|select *
$supervisoryRevPol|export-csv .\Reports\SandCSupervisoryReviewPoliciesV2.csv -NoTypeInformation
#Get-SupervisoryReviewRule
Write-Host "Pulling information about Supervisory Review Rules..." -ForegroundColor Magenta
$supervisoryRevRule=Get-SupervisoryReviewRule|select *
$supervisoryRevRule|export-csv .\Reports\SandCSupervisoryReviewRule.csv -NoTypeInformation

Remove-PSSession $SecurityAndComplianceSession
#endregion

#----------------------------------------------------------
#Skype for Business 
#----------------------------------------------------------
#region
Import-Module LyncOnlineConnector
$SkypeForBusinessSession = New-CsOnlineSession -Credential $msocred
Import-PSSession $SkypeForBusinessSession

#### DEPRECATED
<#
#Tenant
Write-Host "Pulling information about Skype Tenant..." -ForegroundColor Magenta
$cst=Get-CSTenant
$cst|Export-Csv .\Reports\SFBTenant.csv -NoTypeInformation
#Tenant Licensing Configuration
Write-Host "Pulling information about Skype Tenant Licensing Configuration..." -ForegroundColor Magenta
$cstlc=Get-CSTenantLicensingConfiguration
$cstlc|Export-Csv .\Reports\SFBTenantLicensingConfiguration.csv -NoTypeInformation

#External Access Policies
Write-Host "Pulling information about Skype External Access Policies..." -ForegroundColor Magenta
$cseap=Get-CSExternalAccessPolicy
$cseap|Export-Csv .\Reports\SFBExternalAccessPolicies.csv -NoTypeInformation

#Voice Policies
Write-Host "Pulling information about Skype Voice Policies..." -ForegroundColor Magenta
$csvp=Get-CSVoicePolicy
$csvp|Export-Csv .\Reports\SFBVoicePolicies.csv -NoTypeInformation

#IM Filter Configuration
Write-Host "Pulling information about Skype IM Filter Configuration..." -ForegroundColor Magenta
$csimfcon=(Get-CSImFilterConfiguration|select *)
$csimfcon|Export-Csv .\Reports\SFBIMFilterConfiguration.csv -NoTypeInformation
#Presence Policy
Write-Host "Pulling information about Skype Presence Policies..." -ForegroundColor Magenta
$cspp=(Get-CSPresencePolicy|select *)
$cspp|Export-Csv .\Reports\SFBPresencePolicy.csv -NoTypeInformation
#Privacy Configuration
Write-Host "Pulling information about Skype Privacy Configuration..." -ForegroundColor Magenta
$cspc=(Get-CSPrivacyConfiguration|select *)
$cspc|Export-Csv .\Reports\SFBPrivacyConfiguration.csv -NoTypeInformation

#Exchange UM Contacts
Write-Host "Pulling information about Skype Exchange UM Contacts..." -ForegroundColor Magenta
$exumc=(Get-CSExUMContact|select *)
$exumc|Export-Csv .\Reports\SFBExchangeUMContacts.csv -NoTypeInformation

#Tenant Federation Configuration
Write-Host "Pulling information about Skype Tenant Federation Configuration..." -ForegroundColor Magenta
$tfc=(Get-CSTenantFederationConfiguration|select *)
$tfc|Export-Csv .\Reports\SFBTenantFederationConfiguration.csv -NoTypeInformation
#Tenant Hybrid Configuration
Write-Host "Pulling information about Skype Tenant Hybrid Configurations..." -ForegroundColor Magenta
$thc=(Get-CSTenantHybridConfiguration|select *)
$thc|Export-Csv .\Reports\SFBTenantHybridConfiguration.csv -NoTypeInformation
#Tenant Public Provider
Write-Host "Pulling information about Skype Tenant Public Providers..." -ForegroundColor Magenta
$tpp=(Get-CSTenantPublicProvider|select *)
$tpp|Export-Csv .\Reports\SFBTenantPublicProviders.csv -NoTypeInformation

#Meeting Rooms
Write-Host "Pulling information about Skype Meeting Rooms..." -ForegroundColor Magenta
$csmr=(Get-CSMeetingRoom|select *)
$csmr|Export-Csv .\Reports\SFBMeetingRooms.csv -NoTypeInformation
#Audio Conferencing Providers
Write-Host "Pulling information about Skype Audio Conferencing Providers..." -ForegroundColor Magenta
$csacp=Get-CSAudioConferencingProvider
$csacp|Export-Csv .\Reports\SFBAudioConferencingProviders.csv -NoTypeInformation

#Push Notification Configuration
Write-Host "Pulling information about Skype Push Notification Configuration..." -ForegroundColor Magenta
$cspnc=Get-CSPushNotificationConfiguration
$cspnc|Export-Csv .\Reports\SFBPushNotificationConfiguration.csv -NoTypeInformation
#>

#### BROADCAST
Write-Host "Pulling information about Skype Broadcast Meeting Configuration..." -ForegroundColor Magenta
$csbcmc=Get-CsBroadcastMeetingConfiguration|select *
$csbcmc|export-csv .\Reports\SFBBroadcastMeetingConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Skype Broadcast Meeting Policy..." -ForegroundColor Magenta
$csbcmp=Get-CsBroadcastMeetingPolicy|select *
$csbcmp|export-csv .\Reports\SFBBroadcastMeetingPolicy.csv -NoTypeInformation

#### CALLING LINE
Write-Host "Pulling information about Skype Calling Line Identities..." -ForegroundColor Magenta
$cscli=Get-CsCallingLineIdentity|select *
$cscli|export-csv .\Reports\SFBCallingLineIdentities.csv -NoTypeInformation

#### CALL QUEUE
Write-Host "Pulling information about Skype Hunt Groups..." -ForegroundColor Magenta
$cshg=Get-CsHuntGroup|select *
$cshg|export-csv .\Reports\SFBHuntGroups.csv -NoTypeInformation

#### CLIENT POLICY
Write-Host "Pulling information about Skype Client Policies..." -ForegroundColor Magenta
$cscp=Get-CSClientPolicy
$cscp|Export-Csv .\Reports\SFBClientPolicies.csv -NoTypeInformation

#### CLOUD MEETING
Write-Host "Pulling information about Skype Cloud Meeting Configurations..." -ForegroundColor Magenta
$csmc=Get-CSCloudMeetingConfiguration
$csmc|Export-Csv .\Reports\SFBCloudMeetingConfiguration.csv -NoTypeInformation.
Write-Host "Pulling information about Skype Cloud Meeting Policiess..." -ForegroundColor Magenta
$cscmp=Get-CSCloudMeetingPolicy|select *
$cscmp|Export-Csv .\Reports\SFBCloudMeetingPolicies.csv -NoTypeInformation.

#### CONFERENCING POLICY
Write-Host "Pulling information about Skype Conferencing Policies..." -ForegroundColor Magenta
$csconfp=Get-CSConferencingPolicy
$csconfp|Export-Csv .\Reports\SFBConferencingPolicies.csv -NoTypeInformation

#### HYBRID PSTN SITE AND USER
Write-Host "Pulling information about Skype Hybrid Mediation Servers..." -ForegroundColor Magenta
$cshmserver=Get-CsHybridMediationServer|select *
$cshmserver|Export-Csv .\Reports\SFBHybridMediationServers.csv -NoTypeInformation
Write-Host "Pulling information about Skype Hybrid PSTN Sites..." -ForegroundColor Magenta
$cshpstns=Get-CsHybridPSTNSite|select *
$cshpstns|Export-Csv .\Reports\SFBHybridPSTNSites.csv -NoTypeInformation

#### INTERNET PROTOCOL
Write-Host "Pulling information about Skype IP Phone Policy..." -ForegroundColor Magenta
$csippp=Get-CsIPPhonePolicy|select *
$csippp|Export-Csv .\Reports\SFBIPPhonePolicy.csv -NoTypeInformation

#### MOBILE POLICY
Write-Host "Pulling information about Skype Mobility Policy..." -ForegroundColor Magenta
$csmp=Get-CsMobilityPolicy|select *
$csmp|Export-Csv .\Reports\SFBMobilityPolicy.csv -NoTypeInformation

#### DIAL IN CONFERENCING
Write-Host "Pulling information about Skype DialIn Conferencing Bridges..." -ForegroundColor Magenta
$csodicb=Get-CsOnlineDialInConferencingBridge|select *
$csodicb|Export-Csv .\Reports\SFBOnlineDialInConferencingBridges.csv -NoTypeInformation
Write-Host "Pulling information about Skype DialIn Languages Supported..." -ForegroundColor Magenta
$csodils=Get-CsOnlineDialInConferencingLanguagesSupported|select *
$csodils|Export-Csv .\Reports\SFBOnlineDialInLanguagesSupported.csv -NoTypeInformation
Write-Host "Pulling information about Skype DialIn Conferencing Service Number..." -ForegroundColor Magenta
$csodicsn=Get-CsOnlineDialInConferencingServiceNumber|select *
$csodicsn|Export-Csv .\Reports\SFBOnlineDialInConferencingServiceNumber.csv -NoTypeInformation
Write-Host "Pulling information about Skype DialIn Conferencing Tenant Configuration ..." -ForegroundColor Magenta
$csodictc=Get-CsOnlineDialInConferencingTenantConfiguration|select *
$csodictc|Export-Csv .\Reports\SFBOnlineDialInConferencingTenantConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Skype DialIn Conferencing Tenant Settings..." -ForegroundColor Magenta
$csodicts=Get-CsOnlineDialInConferencingTenantSettings|select *
$csodicts|Export-Csv .\Reports\SFBOnlineDialInConferencingTenantSettings.csv -NoTypeInformation

#### ONLINE DIRECTORY
Write-Host "Pulling information about Skype Directory Tenant..." -ForegroundColor Magenta
$csodt=Get-CsOnlineDirectoryTenant|select *
$csodt|Export-Csv .\Reports\SFBOnlineDirectoryTenant.csv -NoTypeInformation
Write-Host "Pulling information about Skype Directory Tenant Number Cities..." -ForegroundColor Magenta
$csodtnc=Get-CsOnlineDirectoryTenantNumberCities|select *
$csodtnc|Export-Csv .\Reports\SFBOnlineDirectoryTenantNumberCities.csv -NoTypeInformation

#### E911 AND LOCATION INFORMATION SERVICE (LIS)
Write-Host "Pulling information about Skype LIS Civic Address..." -ForegroundColor Magenta
$csolisca=Get-CsOnlineLisCivicAddress|select *
$csolisca|Export-Csv .\Reports\SFBOnlineLISLocation.csv -NoTypeInformation
Write-Host "Pulling information about Skype LIS Location..." -ForegroundColor Magenta
$csolislocation=Get-CsOnlineLisLocation|select *
$csolislocation|Export-Csv .\Reports\SFBOnlineLISLocation.csv -NoTypeInformation

#### ONLINE VOICEMAIL
Write-Host "Pulling information about Skype Online Voicemail Policies..." -ForegroundColor Magenta
$cshvp=(Get-CSOnlineVoicemailPolicy|select *)
$cshvp|Export-Csv .\Reports\SFBOnlineVoicemailPolicy.csv -NoTypeInformation

#### ORGANIZATIONAL AUTO ATTENDANT
Write-Host "Pulling information about Skype Organizational AutoAttendants..." -ForegroundColor Magenta
$csorgautoattendants=Get-CsOrganizationalAutoAttendant|select *
$csorgautoattendants|export-csv .\Reports\SFBOrganizationalAutoAttendants.csv -NoTypeInformation
Write-Host "Pulling information about Skype Organizational AutoAttendant Statuses..." -ForegroundColor Magenta
$csorgautoattendantstatusArray=@()
$csorgautoattendantURIs=$csorgautoattendants.primaryuri.originalstring
foreach($csuri in $csorgautoattendantURIs){
    $csorgaastatustemp=Get-CsOrganizationalAutoAttendantStatus -primaryURI $csuri|select *
    $csorgautoattendantstatusArray+=$csorgaastatustemp
}
$csorgautoattendantstatusArray|export-csv .\Reports\SFBOrganizationalAutoAttendantStatuses.csv -NoTypeInformation
Write-Host "Pulling information about Skype Organizational AutoAttendant Supported Languages..." -ForegroundColor Magenta
$csoaasl=(Get-CsOrganizationalAutoAttendantSupportedLanguage|select *)
$csoaasl|Export-Csv .\Reports\SFBOrganizationalAutoAttendantSupportedLanguages.csv -NoTypeInformation
Write-Host "Pulling information about Skype Organizational AutoAttendant Supported Time Zones..." -ForegroundColor Magenta
$csoaastz=(Get-CsOrganizationalAutoAttendantSupportedTimeZone|select *)
$csoaastz|Export-Csv .\Reports\SFBOrganizationalAutoAttendantSupportedTimeZones.csv -NoTypeInformation

#### TENANT DIAL PLAN
Write-Host "Pulling information about Skype Tenant Dial Plans..." -ForegroundColor Magenta
$cstenantDP=(Get-CsTenantDialPlan|select *)
$cstenantDP|Export-Csv .\Reports\SFBTenantDialPlans.csv -NoTypeInformation

#### TENANT HYBRID CONFIGURATION
Write-Host "Pulling information about Skype Tenant Hybrid Configuration..." -ForegroundColor Magenta
$cstenanthybridconfig=(Get-CsTenantHybridConfiguration|select *)
$cstenanthybridconfig|Export-Csv .\Reports\SFBTenantHybridConfiguration.csv -NoTypeInformation

#### VOICE ROUTING POLICY
Write-Host "Pulling information about Skype Voice Routing Policies..." -ForegroundColor Magenta
$csvrp=(Get-CsVoiceRoutingPolicy|select *)
$csvrp|Export-Csv .\Reports\SFBVoiceRoutingPolicies.csv -NoTypeInformation

Remove-PSSession $SkypeForBusinessSession
#endregion