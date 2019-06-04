# FileName:  ps_FindADUsersWithManager.ps1
#----------------------------------------------------------------------------
# Script Name: [Find AD Users and Parse Manager from DN format to Name]
# Created: [08/01/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
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


#Populate Identity Array
[Array] $identities = get-aduser -Filter "*" -Properties Name,DisplayName, Manager, Enabled, LastLogonDate, Mail, physicalDeliveryOfficeName, iffRegionName, iffRegionCode, iffCountryCode, iffCityCode, msExchRecipientTypeDetails, msRTCSIP-DeploymentLocator, msRTCSIP-PrimaryUserAddress | Select DisplayName, Name, UserPrincipalName, Mail, LastLogonDate, Enabled, physicalDeliveryOfficeName, iffRegionName, iffRegionCode, iffCountryCode, iffCityCode, msExchRecipientTypeDetails, msRTCSIP-DeploymentLocator, msRTCSIP-PrimaryUserAddress, Manager #| ? {$_.msExchRecipientTypeDetails -ne 2147483648}

#Initialize array variable used to store records for output

$arrResults = @()
$ismanager = ""
ForEach ($aduser in [Array] $identities)
{
        if ($identities.manager -like "*"+$aduser.Name+"*") {
            $ismanager = "YES"
        } else {
            $ismanager = "NO"; continue
        }

    $manager = ""
#Process mailbox for FullAccess Permissions
trap { 'User: '+$aduser.DisplayName+' has no AD Manager'; continue }
$manager = Get-ADUser -Identity $aduser.Manager -Properties DisplayName

    $objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Display -Value $aduser.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name Name -Value $aduser.Name

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $aduser.UserPrincipalName

    $objEX | Add-Member -MemberType NoteProperty -Name SMTP -Value $aduser.Mail
    
    $objEX | Add-Member -MemberType NoteProperty -Name LastLogin -Value $aduser.LastLogonDate
        
    $objEX | Add-Member -MemberType NoteProperty -Name IsEnabled -Value $aduser.Enabled
        
    $objEX | Add-Member -MemberType NoteProperty -Name Office -Value $aduser.physicalDeliveryOfficeName
        
    $objEX | Add-Member -MemberType NoteProperty -Name Region -Value $aduser.iffRegionName
    
    $objEX | Add-Member -MemberType NoteProperty -Name RegionCode -Value $aduser.iffRegionCode
    
    $objEX | Add-Member -MemberType NoteProperty -Name CountryCode -Value $aduser.iffCountryCode
    
    $objEX | Add-Member -MemberType NoteProperty -Name CityCode -Value $aduser.iffCityCode

    $objEX | Add-Member -MemberType NoteProperty -Name Type -Value $aduser.msExchRecipientTypeDetails

    $objEX | Add-Member -MemberType NoteProperty -Name SIPLoc -Value $aduser.'msRTCSIP-DeploymentLocator'

    $objEX | Add-Member -MemberType NoteProperty -Name SIPAddress -Value $aduser.'msRTCSIP-PrimaryUserAddress'

    $objEX | Add-Member -MemberType NoteProperty -Name ManagerDisplay -Value $manager.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name ManagerAlias -Value $manager.Name

    $objEX | Add-Member -MemberType NoteProperty -Name IsManager -Value $ismanager

    $arrResults += $objEX
    
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\ADUSERWITHMANAGER_RESULT.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Find Mailboxes with Send-As permissions]
#-----------------------------------------------------------------------------
#>