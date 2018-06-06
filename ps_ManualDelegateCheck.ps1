# FileName:  ps_FindADUsersWithManager.ps1
#----------------------------------------------------------------------------
# Script Name: [Find AD Users and Parse Manager from DN format to Name]
# Created: [08/01/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@novatechgroup.onmicrosoft.com
# Requirements: 
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Master user list with location and manager in readable format
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: 
# Time: 
# Issue: New Script. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------


#Populate Users Array
[Array] $identities = get-content 'C:\Temp\delegatecheck.txt'

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($aduser in [Array] $identities)
{
#Is the user on-prem on in the cloud
$where = Get-ADUser -Identity $aduser -Properties DisplayName, msExchRecipientTypeDetails
#Is the user a member of an Editors group
$groups = Get-ADUser -Identity $aduser -Properties MemberOf | Select -ExpandProperty MemberOf 
$groups | Where {($_ | Out-String) -like "*Editors*"}
if ($where.msExchRecipientTypeDetails -eq 1) #user is on premise
    {
    Write-Host -ForegroundColor Green -BackgroundColor Black "Processing on-premise user: " $where.DisplayName $where.UserPrincipalName $aduser
    Get-exlMailboxFolderPermission -identity $aduser":\calendar"
    #Get-E10ADPermission -Identity $aduser | ? {$_.ExtendedRights} | Select User,Identity,ExtendedRights | FT
    Get-EXLADPermission -Identity $aduser | ? {$_.ExtendedRights} | Select User,Identity,ExtendedRights | FT
    Get-EXLMailbox $aduser | ? {$_.GrantSendOnBehalfTo} | Select DisplayName, Name, GrantSendOnBehalfTo | FT
    #get-EXLmailbox $aduser | Get-EXLMailboxPermission | Select User,AccessRights | FT
    get-EXLmailbox $aduser | Get-EXLMailboxPermission | ? {($_.AccessRights -like “*FullAccess*”) -and ($_.IsInherited -eq $false) -and ($_.User -notlike “NT AUTHORITY\SELF”) -and ($_.User -notlike "S-1-5*") -and ($_.User -notlike $Mailbox.PrimarySMTPAddress)} | Select User,AccessRights | FT
    }
else
    {
    Write-Host -ForegroundColor Green -BackgroundColor Black "Processing online user: " $where.DisplayName $where.UserPrincipalName $aduser
    Get-EXOMailboxFolderPermission -identity $aduser":\calendar"
    Get-EXLADPermission -Identity $aduser | ? {$_.ExtendedRights} | Select User,Identity,ExtendedRights | FT
    Get-EXOMailbox $aduser | ? {$_.GrantSendOnBehalfTo} | Select DisplayName, Name, GrantSendOnBehalfTo | FT
    #get-EXOmailbox $aduser | Get-EXOMailboxPermission | Select User,AccessRights | FT
    get-EXOmailbox $aduser | Get-EXOMailboxPermission | ? {($_.AccessRights -like “*FullAccess*”) -and ($_.IsInherited -eq $false) -and ($_.User -notlike “NT AUTHORITY\SELF”) -and ($_.User -notlike "S-1-5*") -and ($_.User -notlike $Mailbox.PrimarySMTPAddress)} | Select User,AccessRights | FT
    }
    




<#
    $objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Display -Value $aduser.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name Name -Value $aduser.Name

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $aduser.UserPrincipalName

    $objEX | Add-Member -MemberType NoteProperty -Name SMTP -Value $aduser.Mail
    
    $objEX | Add-Member -MemberType NoteProperty -Name Office -Value $aduser.physicalDeliveryOfficeName
        
    $objEX | Add-Member -MemberType NoteProperty -Name Region -Value $aduser.iffRegionName
    
    $objEX | Add-Member -MemberType NoteProperty -Name RegionCode -Value $aduser.iffRegionCode
    
    $objEX | Add-Member -MemberType NoteProperty -Name CountryCode -Value $aduser.iffCountryCode
    
    $objEX | Add-Member -MemberType NoteProperty -Name CityCode -Value $aduser.iffCityCode

    $objEX | Add-Member -MemberType NoteProperty -Name Type -Value $aduser.msExchRecipientTypeDetails

    $objEX | Add-Member -MemberType NoteProperty -Name SIPLoc -Value $aduser.'msRTCSIP-DeploymentLocator'

    $objEX | Add-Member -MemberType NoteProperty -Name ManagerDisplay -Value $manager.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name ManagerAlias -Value $manager.Name

    $arrResults += $objEX 
  #>  
}

#$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\ADUSERWITHMANAGER_RESULT.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Find Mailboxes with Send-As permissions]
#-----------------------------------------------------------------------------
#>