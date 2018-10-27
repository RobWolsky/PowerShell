

# FileName:  ps_MobileIron_Groups_O365Migration.ps1
#----------------------------------------------------------------------------
# Script Name: [Remove MDM users from Main group and add to O365 group]
# Created: [12/18/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: CSV file containing users to search by CN or SamAccountName
# Requirements: List relevant identities in c:\Temp\batch_users.csv (header Name)
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: MobileIron group membership assignment for IFF Office 365 EXO migration
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [12/18/2017]
# Time: [17:20]
# Issue: Update for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

$identities = @()
$count = 0
#Populate Identity Array
[Array] $identities = Import-Csv C:\temp\batch_users.csv


ForEach ($User in [Array] $identities)
{
$a = Get-ADUser $User.Name -Properties MemberOf
  if (($a.MemberOf | Out-String).Contains("MDM_Users_Main")) {

    Remove-ADGroupMember MDM_Users_Main $a.Name -Confirm:$false
    Add-ADGroupMember mdm_users_o365 $a.Name -Confirm:$false
    $count++
}
Else {
Write-Host ("User "+$User.Name+" is not a member of the MDM_Users_Main group")
}
}
$count
#-----------------------------------------------------------------------------
# END OF SCRIPT: [Remove MDM users from Main group and add to O365 group]
#-----------------------------------------------------------------------------
#>