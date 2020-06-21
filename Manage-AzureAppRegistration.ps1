<#
.Synopsis
	Manage-AzureAppRegistration creates or modifies an Azure Application Registration for use with Graph

.DESCRIPTION
	This PowerShell script leverages the known PowerShell Client ID while connecting to Microsoft Graph to create or update an Azure Application Registration with the following permissions:
		Windows Azure Active Directory (00000002-0000-0000-c000-000000000000):
			   a42657d6-7f20-40e3-b6f0-cee03008a62a : Allows the app to have the same access to information in the directory as the signed-in user (Directory.AccessAsUser.All).
		Microsoft Graph (00000003-0000-0000-c000-000000000000):
			   02e97553-ed7b-43d0-ab3c-f8bace0d040c : Allows an app to read all service usage reports on behalf of the signed-in user. Services that provide usage reports include Office 365 and Azure Active Directory (Reports.Read.All).
		Office 365 Management APIs (c5393580-f805-4401-95e8-94b7a6ef2fc2):
			   e2cea78f-e743-4d8f-a16a-75b629a038ae : Allows the application to read service health information for your organization (ServiceHealth.Read).
			   594c1fb6-4f81-4475-ae41-0c394909246c : Allows the application to read activity data for your organization (ActivityFeed.Read).
			   4807a72c-ad38-4250-94c9-4eabfe26cd55 : Allows the application to read DLP policy events, including detected sensitive data, for your organization (ActivityFeed.ReadDlp).
			   17f1c501-83cd-414c-9064-cd10f7aef836 : Allows the application to read threat intelligence data for your organization (ThreatIntelligence.Read).
			   b3b78c39-cb1d-4d17-820a-25d9196a800e : Allows the application to read service health information for your organization (ActivityReports.Read).
			   69784729-33e3-471d-b130-744ce05343e5 : Allows the application to read threat intelligence data for your organization (ThreatIntelligence.Read).
			   825c9d21-ba03-4e97-8007-83f020ff8c0f : Allows the application to read service health information for your organization (ActivityReports.Read).	
	The script will output the Application Name, Client ID and a URL for manual consent (usually used for adding the Oauth2 Permissions to other Administrator accounts vs. doing a Global Grant).
	
	Prerequisite (ADAL DLL):
		Azure Active Directory PowerShell Module: https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2
		or
		Azure Service Management PowerShell Module: https://docs.microsoft.com/en-us/powershell/azure/servicemanagement/install-azure-ps
		or
		Azure Resource Manager PowerShell Module: https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps

.NOTES
	NAME:			Manage-AzureAppRegistration.ps1
    VERSION:      	1.0
    AUTHOR:       	Michael LaMontagne 
    LASTEDIT:     	12/26/2017

V 1.0 - Dec 2017 -	Fast Publish.

.LINK
   Website: http://realtimeuc.com
   Twitter: http://www.twitter.com/realtimeuc
   LinkedIn: http://www.linkedin.com/in/mlamontagne/

.EXAMPLE
   .\Manage-AzureAppRegistration.ps1
   
	Description
	-----------
	Prompts for Azure Tenant AD Domain Name (domain.onmicrosoft.com), prompts for Administrative credentials for tenant before creating  the Azure App Registration named "PowerShell-API-AzureApp" with a URL of "http://www.realtimeuc.com".
	
.EXAMPLE
	$cred = get-credential
   .\Manage-AzureAppRegistration.ps1 -AzureTenantADName "customer1.onmicrosoft.com" -AppName "PowerShellIsAwesome-API-AzureApp" -URL "http://www.realtimeuc.com" -Credential $cred -verbose
   
	Description
	-----------
	Creates an Azure App Registration using all available input parameters and turns on verbose logging
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$AzureTenantADName, #domain.onmicrosoft.com 
    [string]$AppName = "PowerShell-API-AzureApp",
    [string]$URL = "http://www.realtimeuc.com",
    [Pscredential]$Credential = $(Get-Credential),
	[switch]$GrantGlobal 
)

#$RequiredresourceAccess contains the Oauth2Permissions required for the Azure Application Registration
$RequiredresourceAccess = @"
#Windows Azure Active Directory	- Access the directory as the signed-in user
    {
      "resourceAppId": "00000002-0000-0000-c000-000000000000",
      "resourceAccess": [
        {
          "id": "a42657d6-7f20-40e3-b6f0-cee03008a62a",
          "type": "Scope"
        }
      ]
    },
#Microsoft Graph - Read all usage reports
    {
        "resourceAppId": "00000003-0000-0000-c000-000000000000",
        "resourceAccess": [
            {
                "id": "02e97553-ed7b-43d0-ab3c-f8bace0d040c",
                "type": "Scope"
            }
        ]
    },
#Office 365 Management APIs - Read All: Service Health, Activity Data, Activity Reports x2, DLP Policy events and Threat Intelligence x2
    {
      "resourceAppId": "c5393580-f805-4401-95e8-94b7a6ef2fc2",
      "resourceAccess": [
        {
          "id": "e2cea78f-e743-4d8f-a16a-75b629a038ae",
          "type": "Scope"
        },
        {
          "id": "594c1fb6-4f81-4475-ae41-0c394909246c",
          "type": "Scope"
        },
        {
          "id": "4807a72c-ad38-4250-94c9-4eabfe26cd55",
          "type": "Scope"
        },
        {
          "id": "17f1c501-83cd-414c-9064-cd10f7aef836",
          "type": "Scope"
        },
        {
          "id": "b3b78c39-cb1d-4d17-820a-25d9196a800e",
          "type": "Scope"
        },
        {
          "id": "69784729-33e3-471d-b130-744ce05343e5",
          "type": "Scope"
        },
        {
          "id": "825c9d21-ba03-4e97-8007-83f020ff8c0f",
          "type": "Scope"
        }
      ]
    }
"@

$RequiredresourceAccess = $RequiredresourceAccess -replace '(?m)(#.*\n)', '' #remove comments from JSON

$adal = $null
$adalPlat = $null
$AppBody = $null
$AppBodyJson = $null
$AppBodyUpdate = $null
$AppCheck = $null
$AppResults = $null
$AuthContext = $null
$AuthResult = $null
$ConsentType = $null
$DifferentURL = @()
$EmptyRequiredResource = $false
$keepRequiredResource = @()
$MatchedRequiredResource = @()
$MeResults = $null
$MissingRequiredResource = @()
$MissingResourceAccess = @()
$modules = @()
$module = $null
$modulebase = $null
$OAuthCheck = $null
$OAuthFilter = $null
$OAuthPermbody = $null
$OAuthPermResults = $null
$PrincipalID = $null
$ServiceBody = $null
$ServiceCheck = $null
$ServicePrincipalsFilter = $null
$ServicePrincipalsResults = $null
$ServiceResults = $null
$UserCreds = $null

$AzureADAuthority = "https://login.windows.net/$azureTenantADName/oauth2/v2.0/authorize" #Authority to Azure AD Tenant
$ResourceURL = "https://graph.windows.net" #Resource URI to the Microsoft Graph
$powerShellClientId = "1950a258-227b-4e31-a9cf-717495945fc2" #PowerShell's clientid known to Azure AD.
$APIBaseURL = "https://graph.windows.net/$AzureTenantADName/" #Microsoft Graph API Base URL
$APIVersion = "?api-version=1.6" #Microsoft Graph API version
$AppFilter = "&`$filter=displayName+eq+'$($AppName)'" #Filter only for AppName

filter equals{
param(
        [Parameter(Position=0, Mandatory=$true,ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $obj
    )

    return $obj|?{$_.sideindicator -eq '=='}
}

filter leftside{
param(
        [Parameter(Position=0, Mandatory=$true,ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $obj
    )

    return $obj|?{$_.sideindicator -eq '<='}
}

#Find and load required DLL for Graph API or end script
$modules = @('Azure','AzureAD','AzureRM')
$modules | % {Import-module $_ -ErrorAction SilentlyContinue}
$module = $(compare-object $(get-module).name $modules -IncludeEqual | equals).InputObject | sort | select -first 1
write-verbose "Using the $module PowerShell Module to load ADAL DLL file(s)"
if ($module) {
    $modulebase = (Get-Module $module | Sort Version -Descending | Select -First 1).ModuleBase
    if ($module -eq "AzureRM") {
        $modulebase = $modulebase -replace '\\AzureRM\\.+$','\AzureRM.profile'
    }
    $adal = $(Get-Childitem -Path $modulebase -Include Microsoft.IdentityModel.Clients.ActiveDirectory.dll -Recurse | sort creationtime -Descending | Select -First 1) 
	write-verbose "Loading: $($adal.FullName)"
    try {Add-Type -Path $adal.FullName} catch {write-error $($_.Exception.Message); Break}
	#starting with AzureAD v2.0.0.98 Microsoft.IdentityModel.Clients.ActiveDirectory.dll also requires Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll and UserCredential changed to UserPasswordCredential
	#At this time (Dec 2017), both the Azure and AzureRM modules do not have this change, but leaving check to future proof.
    $adalPlat = $(Get-Childitem -Path $modulebase -Include Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll -Recurse | sort creationtime -Descending | Select -First 1) 
	write-verbose "Loading: $($adalPlat.FullName)" 
	if($adalPlat){
        try {Add-Type -Path $adalPlat.FullName} catch {write-error $($_.Exception.Message); Break}
    }
}
else{write-error "Missing Prerequisite PowerShell Modules (Either: Azure, AzureAD or AzureRM)"; break}

#Token
if($adalPlat){
    $UserCreds = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserPasswordCredential($Credential.UserName, $Credential.Password)
}
else{
    $UserCreds = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential($Credential.UserName, $Credential.Password)
}
$AuthContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext($AzureADAuthority)
try {$AuthResult = $AuthContext.AcquireToken($resourceURL, $powerShellClientId, $UserCreds)} catch {write-error $($_.Exception.Message); Break}
$RequestHeader = @{
    "Authorization" = $AuthResult.CreateAuthorizationHeader()
    "Content-Type" = "application/json"
}

function URI {
    Param (
    [parameter(Mandatory=$true, Position=0)]
    [ValidateNotNullOrEmpty()]
    $URI,
    [parameter(Mandatory=$false)]
    $Filter
    )

    $BuildURI = $null
    $BuildURI = "$APIBaseURL$URI$APIVersion$Filter"

    return $BuildURI
}

function RestMethod {
    Param (
    [parameter(Mandatory=$true)]
    [ValidateSet("GET","POST","PATCH","DELETE")]
    [String]$Method,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$URI,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    $Headers=$RequestHeader,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Body
    )

    $RestResults = $null
    try {
        if ($PSBoundParameters.ContainsKey("Body")) {
            $RestResults = Invoke-RestMethod -Method $Method -Uri $URI -Headers $Headers -Body $Body
        }
        else {
            $RestResults = Invoke-RestMethod -Method $Method -Uri $URI -Headers $Headers
        }
        write-verbose ''
        write-verbose "RESULTS for $($Method) to $($URI) $($Body):"
        write-verbose ''
        write-verbose $RestResults
    }
    catch {
        write-error "Get ($URI): $($_.Exception.Message)"
        Break
    }
    return $RestResults
}


$MeResults = RestMethod -Method "Get" -URI $(URI 'me')
write-verbose $MeResults

$AppCheck = RestMethod -Method "Get" -URI $(URI 'applications' -filter $AppFilter)

$AppBody = @"
    {
	    "odata.type": "Microsoft.DirectoryServices.Application",
	    "objectType": "Application",
	    "availableToOtherTenants": false,
	    "displayName": "$($AppName)",
	    "publicClient": true,
	    "replyUrls": [
	        "$($URL)"
	    ],
	    "requiredResourceAccess": [
            $RequiredresourceAccess
	    ]
    }
"@

if($AppCheck.value){
    $AppBodyJson = $AppBody | ConvertFrom-Json
    $DifferentURL = $(compare-object $appbodyJson.replyUrls $appcheck.value.replyUrls | leftside).InputObject
    if($appcheck.value.requiredResourceAccess){
        $MissingRequiredResource = $(compare-object $appbodyJson.requiredResourceAccess $appcheck.value.requiredResourceAccess | leftside).InputObject
        $MissingResourceAccess = $(compare-object $appbodyJson.requiredResourceAccess.resourceAccess.id $appcheck.value.requiredResourceAccess.resourceAccess.id | leftside).InputObject
    }
    else{$EmptyRequiredResource = $true}

    if($DifferentURL -or $MissingRequiredResource -or $MissingResourceAccess -or $EmptyRequiredResource){
        write-verbose "$($AppName) Updating: $($DifferentURL) $($MissingRequiredResource) $($MissingResourceAccess)"
        $MatchedRequiredResource = $(Compare-Object $appcheck.value.requiredResourceAccess.resourceappid $appbodyJson.requiredResourceAccess.resourceappid -IncludeEqual | equals).InputObject
            if($MatchedRequiredResource){
                foreach($MRR in $MatchedRequiredResource){
                   $MissingResourceAccess = $(Compare-Object $($appcheck.value.requiredResourceAccess | ? {$_.resourceappid -eq $MRR}).resourceAccess.id $($appbodyJson.requiredResourceAccess | ? {$_.resourceappid -eq $MRR}).resourceAccess.id | leftside).InputObject                    
                    if($MissingResourceAccess){
                        foreach($MRA in $MissingResourceAccess){
$missing = @"
    {
        "id": "$($MRA)",
        "type": "Scope"
    }
"@
                            $appbodyJson.requiredResourceAccess[$appbodyJson.requiredResourceAccess.resourceappid.indexof($MRR)].resourceAccess += $Missing | ConvertFrom-Json
                        }
                    }
                }
            }
        $keepRequiredResource = $(Compare-Object $appcheck.value.requiredResourceAccess.resourceappid $appbodyJson.requiredResourceAccess.resourceappid | leftside).InputObject
            if($keepRequiredResource){
                foreach($KRR in $keepRequiredResource){
                    $appbodyJson.requiredresourceaccess += $appcheck.value.requiredResourceAccess | ? {$_.resourceappid -eq $KRR}
                }
            }

$AppBodyUpdate = @"
    {
        "odata.type": "Microsoft.DirectoryServices.Application",
        "objectType": "Application",
        "availableToOtherTenants": false,
        "displayName": "$($AppName)",
        "publicClient": true,
        "replyUrls": [
            "$($URL)"
        ],
        "requiredResourceAccess":  $(ConvertTo-Json -InputObject @($($appbodyJson.requiredResourceAccess)) -Depth 3)
    }
"@

        if(!($AppBody -eq $AppBodyUpdate)){
            write-verbose "Updating Azure App $($AppName) with $AppBodyUpdate"
            $AppResults = RestMethod -Method "Patch" -URI $(URI "applications/$($AppCheck.value.objectid)") -Body $AppBodyUpdate
            $AppCheck = RestMethod -Method "Get" -Uri $(URI 'applications' -filter $AppFilter)
        }
    }

}
else{
    write-verbose "Creating Azure App $($AppName)"
    $AppResults = RestMethod -Method "Post" -URI $(URI 'applications') -Body $AppBody
    $AppCheck = RestMethod -Method "Get" -Uri $(URI 'applications' -filter $AppFilter)
}

$ServiceCheck = RestMethod -Method "Get" -Uri $(URI 'servicePrincipals' -filter $AppFilter)

if(!$ServiceCheck.value -and $AppCheck.value){

$ServiceBody = @"
    {
        "odata.type": "Microsoft.DirectoryServices.ServicePrincipal",
        "objectType": "ServicePrincipal",
        "appId": "$($AppCheck.value.appid)",
        "displayName": "$($AppName)",
        "servicePrincipalNames": [
	        "$($AppCheck.value.appid)"
        ],
        "servicePrincipalType": "Application",
        "tags": []
    }
"@

    write-verbose "Creating Service Principal for Azure App $($AppName)"
    $ServiceResults = RestMethod -Method "Post" -Uri $(URI 'servicePrincipals') -Body $ServiceBody
    $ServiceCheck = RestMethod -Method "Get" -Uri $(URI 'servicePrincipals' -filter $AppFilter)
}

$OAuthFilter = "&`$filter=clientId+eq+'$($ServiceCheck.value.objectId)'"
$OAuthCheck = RestMethod -Method "Get" -Uri $(URI 'oauth2PermissionGrants' -Filter $OAuthFilter)

if($GrantGlobal) {
    $ConsentType = "AllPrincipals"
    $PrincipalID = "null"
}
else{
    $ConsentType = "Principal"
    $PrincipalID = """$($MeResults.objectId)"""
}

if($OauthCheck.value){
    $count = 0
    foreach ($ResourceID in $AppCheck.value.requiredresourceaccess.resourceappid){
        $Scopes = @()
        $ServicePrincipalsFilter = $null
        $ServicePrincipalsResults = $null
        $IDs = $($AppCheck.value.requiredresourceaccess[$count].resourceAccess.id)
        $ServicePrincipalsFilter = "&`$filter=appId+eq+'$($ResourceID)'"
        $ServicePrincipalsResults = RestMethod -Method "Get" -Uri $(URI 'servicePrincipals' -filter $ServicePrincipalsFilter)
            foreach ($ID in $IDs){
                $Scope = $($ServicePrincipalsResults.value.oauth2permissions | ? {$_.id -eq $ID}).value
                if($Scope){$Scopes += $Scope}
            }
        $ScopeObject = $($ServicePrincipalsResults.value | ? {$_.appid -eq "$ResourceID"}).objectid
            if($ScopeObject -and $Scopes){
                Write-Verbose "$ScopeObject : $Scopes"

$OAuthPermbody = @"
	{
		"odata.type": "Microsoft.DirectoryServices.OAuth2PermissionGrant",
		"clientId": "$($ServiceCheck.value.objectId)",
		"consentType": "$($ConsentType)",
		"principalId": $($PrincipalID),
		"resourceId": "$($ScopeObject)",
		"scope": "$($Scopes)",
		"startTime": "0001-01-01T00:00:00",
		"expiryTime": "9000-01-01T00:00:00"
    }
"@

                Write-Verbose $OAuthPermbody
                $SpecificOauth = $OauthCheck.value | ? {$_.resourceid -eq $ScopeObject}

                if ($SpecificOauth){
                    if(!($($OauthCheck.value.scope) -like "*$(($OAuthPermbody | ConvertFrom-Json).scope)*")){
                        Write-Verbose "Adding Oauth2 Permission of $OAuthPermbody"
                        $OAuthPermResults = RestMethod -Method "Patch" -Uri $(URI "oauth2PermissionGrants/$($SpecificOauth.objectid)") -Body $OAuthPermbody
                    }
                }
                else{
                    write-verbose "Creating Oauth2 Permission of $OAuthPermbody"
                    $OAuthPermResults = RestMethod -Method "Post" -Uri $(URI 'oauth2PermissionGrants') -Body $OAuthPermbody
                }
            }
            else{
                if(!$ScopeObject){write-error "Missing ServicePrincipal with APP ID: $ResourceID in Tenant: $AzureTenantADName"}
                if(!$Scopes){write-error "Missing one or more of the following Oauth2Permissions: $IDs in Tenant: $AzureTenantADName"}
            }
        $count ++
    }
    $count = $null
    $OAuthCheck = RestMethod -Method "Get" -Uri $(URI 'oauth2PermissionGrants' -filter $OAuthFilter)
}
elseif(!$OauthCheck.value -and $ServiceCheck.value -and $AppCheck.value){
    $count = 0
    foreach ($ResourceID in $AppCheck.value.requiredresourceaccess.resourceappid){
        $Scopes = @()
        $ServicePrincipalsFilter = $null
        $ServicePrincipalsResults = $null
        $IDs = $($AppCheck.value.requiredresourceaccess[$count].resourceAccess.id)
        $ServicePrincipalsFilter = "&`$filter=appId+eq+'$($ResourceID)'"
        $ServicePrincipalsResults = RestMethod -Method "Get" -Uri $(URI 'servicePrincipals' -filter $ServicePrincipalsFilter)
            foreach ($ID in $IDs){
                $Scope = $($ServicePrincipalsResults.value.oauth2permissions | ? {$_.id -eq $ID}).value
                if($Scope){$Scopes += $Scope}
            }
        $ScopeObject = $($ServicePrincipalsResults.value | ? {$_.appid -eq "$ResourceID"}).objectid
            if($ScopeObject -and $Scopes){
                Write-Verbose "$ScopeObject : $Scopes"

$OAuthPermbody = @"
	{
		"odata.type": "Microsoft.DirectoryServices.OAuth2PermissionGrant",
		"clientId": "$($ServiceCheck.value.objectId)",
		"consentType": "$($ConsentType)",
		"principalId": $($PrincipalID),
		"resourceId": "$($ScopeObject)",
		"scope": "$($Scopes)",
		"startTime": "0001-01-01T00:00:00",
		"expiryTime": "9000-01-01T00:00:00"
    }
"@

                write-verbose "Creating Oauth2 Permission of $OAuthPermbody"
                $OAuthPermResults = RestMethod -Method "Post" -Uri $(URI 'oauth2PermissionGrants') -Body $OAuthPermbody
            }
            else{
                if(!$ScopeObject){write-error "Missing ServicePrincipal with APP ID: $ResourceID in Tenant: $AzureTenantADName"}
                if(!$Scopes){write-error "Missing one or more of the following Oauth2Permissions: $IDs in Tenant: $AzureTenantADName"}
            }
         $count ++
    }
    $count = $null
    $OAuthCheck = RestMethod -Method "Get" -Uri $(URI 'oauth2PermissionGrants' -filter $OAuthFilter)
}

if($AppCheck.value){
    $AppCheck.value | Add-Member -MemberType NoteProperty -Name ConsentURL -Value $("https://login.microsoftonline.com/common/oauth2/authorize?response_type=id_token&client_id=$($AppCheck.value.appid)&redirect_uri=$($URL)&prompt=consent") -verbose
}

write-verbose ''
write-verbose "Application Details:"
$AppCheck.value | write-verbose
write-verbose ''
write-verbose "Service Principal Details:"
$ServiceCheck.value | write-verbose 
write-verbose ''
write-verbose "Oauth Permission Details:"
$OauthCheck.value | write-verbose 
write-output ''
write-output '==================================================================================================================================================='
write-output ''
write-output "To access $($AppCheck.value.displayname), use '$($AppCheck.value.appid)' Client ID."
write-output ''
write-output ''
write-output "To manually add permissions to a user for $($AppCheck.value.displayname), browse to: "
write-output ''
write-output "$($AppCheck.value.consenturl)"
write-output ''
write-output '==================================================================================================================================================='