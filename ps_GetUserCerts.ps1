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


#Populate Identity Array
[Array] $usercerts = Get-ChildItem Cert:\CurrentUser

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($cert in [Array] $usercerts)
{

#Find Certs
#trap { 'User: '+$aduser.DisplayName+' has no AD Manager'; continue }

$details = Get-ChildItem Cert:\CurrentUser\$cert | Select * | Out-GridView
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