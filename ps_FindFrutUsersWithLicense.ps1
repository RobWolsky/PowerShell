# FileName:  ps_FindFrutUsersWithLicense.ps1
#----------------------------------------------------------------------------
# Script Name: [Find Migrated Frutarom Users and search for assiged E1 or E3 license]
# Created: [02/25/2020]
# Author: Rob Wolsky
# Company: IFF
# Email: rob.wolsky@iff.com
# Requirements: 
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Frutarom Migrated User Inventory with E3 status
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
[Array] $identities = Get-EXORecipient -ResultSize Unlimited | Where {($_.RecipientType -eq "UserMailbox") -AND (($_.PrimarySMTPAddress -like "*frutarom.com*")-OR ($_.PrimarySMTPAddress -like "*ibrweb.com*") -OR ($_.PrimarySMTPAddress -like "*taiga*") -OR ($_.PrimarySMTPAddress -like "*savoury*") -OR ($_.PrimarySMTPAddress -like "*nutrafur*") -OR ($_.PrimarySMTPAddress -like "*ingrenat*") -OR ($_.PrimarySMTPAddress -like "*extrakt*") -OR ($_.PrimarySMTPAddress -like "*aromco*") -OR ($_.PrimarySMTPAddress -like "*vaya*") -OR ($_.PrimarySMTPAddress -like "*enzym*"))} | Select DisplayName, RetentionPolicy, PrimarySMTPAddress, WindowsLiveID 

#Initialize array variable used to store records for output

$arrResults = @()
$isLicensed = ""
ForEach ($exouser in [Array] $identities)
{
    
trap { 'User: '+$exouser.DisplayName+' is not Licensed'; continue }
$license = (Get-MSOLUser -UserPrincipalName $exouser.WindowsLiveID).Licenses | ? {$_.AccountSKUID -like "*PACK*" }
$service = $license | Select-Object -ExpandProperty ServiceStatus
$status = $service | ? {$_.ServicePlan.ServiceName -like "*OFFICE*"} | Select ProvisioningStatus

$objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Display -Value $exouser.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name Policy -Value $exouser.RetentionPolicy

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $exouser.WindowsLiveID

    $objEX | Add-Member -MemberType NoteProperty -Name SMTP -Value $exouser.PrimarySMTPAddress
   
    $objEX | Add-Member -MemberType NoteProperty -Name EnterpriseLicenseSku -Value $license.AccountSkuId

    $objEX | Add-Member -MemberType NoteProperty -Name ActivationStatus -Value $status.ProvisioningStatus

    $arrResults += $objEX
    
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\ADUSERWITHMANAGER_RESULT.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [ps_FindFrutUsersWithLicense.ps1]
#-----------------------------------------------------------------------------
#>