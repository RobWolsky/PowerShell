### Only works on INTERNAL networks connecting to the internal FQDN of an Exchange CAS server.

####################################################################################################################################
###                                                                                                                              ###
###  	Script by Terry Munro -                                                                                                  ###
###     Technical Blog -               http://365admin.com.au                                                                    ###
###     GitHub Repository -            http://github.com/TeamTerry                                                               ###
###     TechNet Gallery Scripts -      http://tinyurl.com/TerryMunroTechNet                                                      ###
###     Webpage -                      http://docs.com/terry-munro                                                               ###
###     TechNet Download link          https://gallery.technet.microsoft.com/Office-365-Hybrid-Azure-354dc04c                    ###
###                                                                                                                              ###
###     Version 1.1 - 16/05/2017                                                                                                 ###
###     Revision -                                                                                                               ###
###               v1.0  14/05/2017     Initial script                                                                            ###
###               v1.1  18/05/2017     Added Support Guides URL and TechNet download link - Removed message from cred pop-up     ###
###               v1.2  30/05/2017     Added connection to Azure AD Connect (DirSync) Server                                     ###
###                                                                                                                              ###
###     Guideance on Remote Azure AD Sync - https://community.spiceworks.com/topic/724324-invoke-command-import-module           ###
###                                                                                                                              ###
###     Please ensure you read and understand the Notes for Usage below                                                          ###
###                                                                                                                              ###
###                                                                                                                              ###
####################################################################################################################################

####  Notes for Usage  ##############################################################################
#                                                                                                   #
#  Ensure you update the six variables in the script section                                        #
#  - $Tenant - Edit this with your Office 365 tenant name                                           #
#  - $LocalExchServer - Edit this with your local Exchange CAS Server name                          #
#  - $LocalCredential - Edit this with your domain name and Exchange - AD adminstrator account      #
#  - $CloudCred - Enter your Office 365 user name, including the tenant                             #
#  - $AzureADConnect - Enter the FQDN of your Azure AD Connect server                               #
#  - $AzureADCred - Enter the credentials of your Azure AD Connect account (internal admin)         #
#                                                                                                   #
#  Support Guides -                                                                                 #
#   - Pre-Requisites - Configuring your PC                                                          #
#   - - -  http://www.365admin.com.au/2017/05/how-to-configure-your-desktop-pc-for.html             #
#   - Usage Guide - Editing the connection script                                                   #
#   - - - http://www.365admin.com.au/2017/05/how-to-connect-to-hybrid-exchange.html                 #
#                                                                                                   #
#####################################################################################################


#####################################################################################################

###                      Edit the six variables below with your details                          ###

$Tenant = "iff"

$LocalExchServer = "iffandhyb01.mail.global.iff.com"
$Local2010Server = "iffandmbx01.mail.global.iff.com"
$AzureExchServer = "naazeexhybpv1.mail.global.iff.com"

$LocalCredential = Get-Credential "global\rxw1401_e"

$CloudCred = Get-credential "rob.wolsky@iff.com"

$AzureADConnect = "fed.iff.com"

$AzureADCred = "global\rxw1401_e"


#####################################################################################################


###  SharePoint Online
Import-Module Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url "https://$($Tenant)-admin.sharepoint.com" -Credential $CloudCred


###   Active Directory Local
Import-Module ActiveDirectory


###   Exchange 2010 Local
$E10Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$($Local2010Server)/PowerShell/ -Authentication Kerberos -Credential $LocalCredential
Import-PSSession $E10Session -AllowClobber -Prefix E10
Set-E10AdServerSettings -ViewEntireForest $True

###   Exchange Local
$EXLSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$($LocalExchServer)/PowerShell/ -Authentication Kerberos -Credential $LocalCredential
Import-PSSession $EXLSession -AllowClobber -Prefix EXL
Set-EXLAdServerSettings -ViewEntireForest $True

###   Azure Exchange Local
$AzureExchServer = "naazeexhybpv1.mail.global.iff.com"
$LocalCredential = Get-Credential "global\rxw1401_e"
$EXLSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$($AzureExchServer)/PowerShell/ -Authentication Kerberos -Credential $LocalCredential
Import-PSSession $EXLSession -AllowClobber -Prefix EXL
Set-EXLAdServerSettings -ViewEntireForest $True


###   Exchange Online - New Module May 2020
Install-Module ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName rob.wolsky@iff.com -ShowProgress $true
# $EXOSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $CloudCred -Authentication Basic -AllowRedirection
# Import-PSSession $EXOSession -AllowClobber -Prefix EXO

###   Exchange Online - Enzymotec/Vaya
$ECred = get-credential
$ENZSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $ECred -Authentication Basic -AllowRedirection
Import-PSSession $ENZSession -AllowClobber -Prefix ENZ


### Exchange Online Protection
$EOPSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.protection.outlook.com/powershell-liveid/ -Credential $CloudCred -Authentication Basic -AllowRedirection
Import-PSSession $EOPSession -AllowClobber -Prefix EOP


### Compliance Center
$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.compliance.protection.outlook.com/powershell-liveid/" -Credential $CloudCred -Authentication "Basic" -AllowRedirection
Import-PSSession $ccSession -AllowClobber -Prefix CC


### Azure Active Directory Rights Management
Import-Module AADRM
Connect-AadrmService -Credential $CloudCred


### Azure Resource Manager
Login-AzureRmAccount -Credential $CloudCred


###   Azure Active Directory v1.0
Import-Module MsOnline
Connect-MsolService #-Credential rob.wolsky@iff.com


###  SharePoint Online
Import-Module Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url "https://iff-admin.sharepoint.com"


### Skype Online
Import-Module SkypeOnlineConnector
$SkypeSession = New-CsOnlineSession #-Credential rob.wolsky@iff.com -OverrideAdminDomain "iff.onmicrosoft.com"
Import-PSSession $SkypeSession -AllowClobber

### Skype/Lync Local
#$LocalCredential = Get-Credential
$LyncSession = New-PSSession -ConnectionUri "https://iffandfe04.mail.global.iff.com/PowerShell" -Credential $LocalCredential
Import-PSSession $LyncSession -AllowClobber

$Lync = New-PSSession -ComputerName "iffandfe04.mail.global.iff.com"
Invoke-Command -Session $Lync { Import-Module Lync }
Import-PSSession -Session $Lync -Module Lync

### Skype/Lync BTOCM
$LocalCredential = Get-Credential
$LyncSession = New-PSSession -ConnectionUri "https://lonwebint01.iff.com/Powershell" -Credential $LocalCredential
Import-PSSession $LyncSession -AllowClobber

### Azure AD v2.0
Connect-AzureAD -Credential $CloudCred


### Azure AD Connect (DirSync)
$ADConnectSession -= -New-PSSession--Computername-$AzureADConnect -Credential $AzureADCred
Invoke-Command--Session-$ADConnectSession- { Import-Module-ADSync }
Import-PSSession--Session-$ADConnectSession--Module-ADSync-

### Connect to Teams
Import-Module MicrosoftTeams
Connect-MicrosoftTeams #-UserName $CloudCred
