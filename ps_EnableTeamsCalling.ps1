#ENABLE CALLING FOR 1 USER

try{
Write-Output "======================================================="
Write-Host "========== ENABLE CALLING FEATURE ON 1 USER ===========" -foreground "yellow"
Write-Output "======================================================="
$useName = read-host "On which user do you want to enable the calling feature? Ex: name@domain.com"
Grant-CsTeamsCallingPolicy -PolicyName Tag:AllowCalling -Identity $useName -ErrorAction Stop
Write-Output "======================================================="
Write-Host "=============== CALLING FEATURE ENABLED ===============" -foreground "green"
Write-Output "======================================================="
Write-Host "Provisioning, please wait..." -ForegroundColor DarkCyan
Start-Sleep -s 15
Get-CsOnlineUser $useName | ft display*,userprin*,teamscallingpolicy
}catch{

Write-Warning -Message "PROCESS - Error while enabling teams calling feature on the selected user"
Write-Warning -Message $error[0].exception.message}

<#
#ENABLE CALLING FOR ALL USERS

try{
$UserCredential = Get-Credential
Import-Module SkypeOnlineConnector
$sfboSession = New-CsOnlineSession -Credential $UserCredential
Import-PSSession $sfboSession

}catch{
Write-Warning -Message "PROCESS - Error while connecting to skype for business"
Write-Warning -Message $error[0].exception.message}

try{
Write-Output "======================================================="
Write-Host "========= ENABLE CALLING FEATURE ON ALL USERS =========" -foreground "yellow"
Write-Output "======================================================="

$CSUsers = Get-CsOnlineUser
Grant-CsTeamsCallingPolicy -PolicyName Tag:AllowCalling -Identity $CSUsers -Global -erroraction stop
Write-Output "======================================================="
Write-Host "=============== CALLING FEATURE ENABLED ===============" -foreground "green"
Write-Output "======================================================="
Write-Host "Provisioning, please wait..." -ForegroundColor DarkCyan

Start-Sleep -s 15

Get-CsOnlineUser | ft display*,userprin*,teamscallingpolicy

}catch{
Write-Warning -Message "PROCESS - Error while enabling teams calling feature on all users"
Write-Warning -Message $error[0].exception.message}
#>