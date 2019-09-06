####################################################################################################################################################################
# Requirements:
# Skype PowerShell Module
# Exchange Online PowerShell Module
# MSONLINE PowerShell Module
# Global Admin to 365
# CSV Containing Room Lists with columns containing identity,license,usagelocation
#                  Identity = UPN
#                  License = VOICEUS or VOICEINTL
#                  UsageLocation = 2 digit country abbreviation (US, DE, GB, etc.)
#
# Sessions use prefix to connect to O365 (O365)
####################################################################################################################################################################

#Connect to 365
$365Admin = Get-Credential
$Session365 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $365Admin -Authentication Basic  -AllowRedirection
$Skype365= New-CsOnlineSession #-OverrideAdminDomain iff.onmicrosoft.com

Import-PSSession $Session365 -prefix O365 -DisableNameChecking
Import-PSSession $Skype365 -DisableNameChecking 
Connect-MsolService -Credential $365Credential

####################################################################################################################################################################
#Assign license function

function Assign-Voice

{

Param(

[Parameter(Mandatory=$true)]
[string] $UPN,
[string] $License,
[string] $usagelocation

)
$ErrorActionPreference = "SilentlyContinue"
$License ="$License".ToUpper()
$userValidate=get-msoluser -UserPrincipalName $UPN
IF ($?)
{

    IF ($License -eq "VOICEUS" -and $usagelocation -notlike $null) {
        set-msoluser -UserPrincipalName $UPN -UsageLocation $usagelocation
            Start-Sleep -Milliseconds 50
        set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses "IFF:ENTERPRISEPACK"
        Set-MsoluserLicense -UserPrincipalName $UPN -AddLicenses "IFF:MCOPSTN1"
        set-MsoluserLicense -UserPrincipalName $UPN -AddLicenses "IFF:MCOEV"
        set-MsoluserLicense -UserPrincipalName $UPN -AddLicenses "IFF:MCOMEETADV"
            Start-Sleep -Milliseconds 50
        Get-MsolUser -UserPrincipalName $UPN | select DisplayName,Licenses,UsageLocation
        }
    ELSEIF ($License -eq "VOICEINTL" -and $usagelocation -notlike $null){
        set-msoluser -UserPrincipalName $UPN -UsageLocation $usagelocation
            Start-Sleep -Milliseconds 50
        set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses "IFF:ENTERPRISEPACK"
        set-MsoluserLicense -UserPrincipalName $UPN -AddLicenses "IFF:MCOPSTN2"
        set-MsoluserLicense -UserPrincipalName $UPN -AddLicenses "IFF:MCOEV"
        set-MsoluserLicense -UserPrincipalName $UPN -AddLicenses "IFF:MCOMEETADV"          
            Start-Sleep -Milliseconds 50
        Get-MsolUser -UserPrincipalName $UPN | select DisplayName,Licenses
        }
    ELSE {
        Write-Host "You have inserted an incorrect license value or locaton." -ForegroundColor Red}
        
        }  

ELSE{
    write-host "Username or location is invalid." -ForegroundColor Yellow
    }
}

####################################################################################################################################################################
#File prompt to select CSV file
Function Get-FileName($initialDirectory)
{   
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.initialDirectory = $initialDirectory
$OpenFileDialog.filter = "All files (*.*)| *.*"
$OpenFileDialog.ShowDialog() | Out-Null
$OpenFileDialog.filename


}

######################################################################################################################################
#Begin
$File=Get-FileName
[array]$rooms=import-csv $File

If ($File -eq "")

{
    Write-Host ""
    Write-host "You did not select a file." -ForegroundColor Yellow
    Write-Host ""
    break
}

$checkfile=read-host "You have selected $File, is this correct(y or n)?"
$checkfile=$checkfile.ToUpper()

If ($checkfile -ne "Y")

{
    write-host "Script terminated" -ForegroundColor Yellow
    break
}

forEach ($room in $rooms) 

{

#Exchange Tasks
    Set-o365CalendarProcessing -Identity $room.identity -AutomateProcessing AutoAccept -AddOrganizerToSubject $false -RemovePrivateProperty $false -DeleteComments $false -DeleteSubject $false –AddAdditionalResponse $true –AdditionalResponse "Your meeting is now scheduled and if it was enabled as a Skype Meeting will provide a seamless click-to-join experience from the conference room."
    Set-o365mailbox -Identity $room.identity -MailTip "This room is equipped to support Skype for Business Meetings"
    
#Skype Tasks
    $pool="sippoolBLU1A11.infra.lync.com"
    Enable-CsMeetingRoom -Identity $room.identity -RegistrarPool $pool -SipAddressType EmailAddress

#Assign Licenses
    $UPN = $room.identity
    $usagelocation=$room.usagelocation
    $license=$room.license
    Assign-Voice -UPN $UPN -License $license -usagelocation $usagelocation

#Write Attributes to IFF and BT AD
    #Add-IFFSkype -IFFUser $sam -SipAddress $sip
    #Add-BTSkype -BTUser $sam -SipAddress $sip
}
