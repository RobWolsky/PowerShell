#Parameters
$clientId = “1950a258-227b-4e31-a9cf-717495945fc2”
$redirectUri = “urn:ietf:wg:oauth:2.0:oob”
$resourceURI = “https://graph.microsoft.com”
$authority = “https://login.microsoftonline.com/common”
$authContext = New-Object “Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext” -ArgumentList $authority
$Office365Username='psautomation@iff.onmicrosoft.com'
$Office365Password='BigBoy2512'

#pre requisites
try {

$AadModule = Import-Module -Name AzureAD -ErrorAction Stop -PassThru

}

catch {

throw ‘Prerequisites not installed (AzureAD PowerShell module not installed)’

}
$adal = Join-Path $AadModule.ModuleBase “Microsoft.IdentityModel.Clients.ActiveDirectory.dll”
$adalforms = Join-Path $AadModule.ModuleBase “Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll”

[System.Reflection.Assembly]::LoadFrom($adal) | Out-Null

[System.Reflection.Assembly]::LoadFrom($adalforms) | Out-Null

##option without user interaction

if (([string]::IsNullOrEmpty($Office365Username) -eq $false) -and ([string]::IsNullOrEmpty($Office365Password) -eq $false))
{
$SecurePassword = ConvertTo-SecureString -AsPlainText $Office365Password -Force
#Build Azure AD credentials object
$AADCredential = New-Object “Microsoft.IdentityModel.Clients.ActiveDirectory.UserPasswordCredential” -ArgumentList $Office365Username,$SecurePassword
# Get token without login prompts.
$authResult = [Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContextIntegratedAuthExtensions]::AcquireTokenAsync($authContext, $resourceURI, $clientid, $AADCredential);

}
else
{
# Get token by prompting login window.
$platformParameters = New-Object “Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters” -ArgumentList “Always”

$authResult = $authContext.AcquireTokenAsync($resourceURI, $ClientID, $RedirectUri, $platformParameters)

}

$accessToken = $authResult.result.AccessToken

$p = Invoke-GraphRequest -Uri https://graph.microsoft.com/v1.0/groups/32fe1fd8-02df-4721-a005-876054cdf0a9/planner/plans -Method GET -AccessToken $accessToken
$plans = $p.result.content | ConvertFrom-Json | select -expand value | select id, title
$plans
