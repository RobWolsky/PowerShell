# FileName:  ps_LicenseUserandSetLocation.ps1
#----------------------------------------------------------------------------
# Script Name: [Grant IFF user an E1 License and set Usage Location to Country Code]
# Created: [12/20/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@novatechgroup.onmicrosoft.com
# Requirements: CSV file containing user UPN's to license post-migration
# Requirements: List relevant identities in c:\Temp\upn_batch.csv (header UPN)
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: First pass of batch generation - Groups with Full Access permissions
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [12/20/2017]
# Time: [09:00]
# Issue: Update for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

$a = Get-MsolUser -All | ? {(($_.Licenses | Out-String) -notlike "*PACK*") -and (($_.BlockCredential -ne $true) -and ($_.MSExchRecipientTypeDetails -ne $null) -and ($_.MSExchRecipientTypeDetails -eq 1)) } 

ForEach ($User in $a)
{
    $loc = get-aduser -Filter 'UserPrincipalName -eq $User.UserPrincipalName' -Properties iffCountryCode #| Select Name, iffCountryCode | Out-GridView
    Set-MsolUser -UserPrincipalName $User.UserPrincipalName -UsageLocation $loc.iffCountryCode
    Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses "IFF:STANDARDPACK"
    
    #Verify
    #Get-MsolUser -UserPrincipalName $User.UserPrincipalName | Select UserPrincipalName, Licenses, UsageLocation
    
    #Cleanup
    $loc = $null
    
}
#>

<#
#-----------------------------------------------------------------------------
# END OF SCRIPT: [Create Batches from Full Access Groups]
#-----------------------------------------------------------------------------
#>