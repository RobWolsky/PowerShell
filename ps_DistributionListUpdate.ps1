# FileName:  ps_DistributionListUpdate.ps1
#----------------------------------------------------------------------------
# Script Name: [Update Distribution Lists from OU, replace DDL function]
# Created: [11/06/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: OU and Distribution Group pairs are embedded in the script
# Requirements: These must be updated as required to reflect changes in AD
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Create a process to duplicate DDL functionality post O365 migration
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [11/06/2017]
# Time: [09:29]
# Issue: First revision. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

#Initialize Hash Table to store OU/Distribution Group input pairs
$OUandGROUP = @{}

#Populate Hash Table with OU's and target Distribution Groups
$OUandGROUP.Add("global.iff.com/IFF/NA/US/PH/EMPLOYEE", "exPS_AllPhillyEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/PH/NONEMPLOYEES", "exPS_AllPhillyNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/FC/EMPLOYEE", "exPS_AllFolcroftEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/FC/NONEMPLOYEES", "exPS_AllFolcroftNonEmp")

#Enumerate Hash Table and update group memberships

$OUandGROUP.GetEnumerator() | ForEach-Object{
        $OU = $_.Key
        $GROUP = $_.Value
#        $message = 'OU {0} users will be added to Group: {1}' -f $OU, $GROUP
#        Write-Host $message -fore gray -back cyan
        $a = Get-EXLRecipient -RecipientType MailUser, UserMailbox -OrganizationalUnit $OU | Select Name, SamAccountName, PrimarySMTPAddress, RecipientType, OrganizationalUnit
        Update-EXLDistributionGroupMember -Identity $GROUP -Members $a.PrimarySMTPAddress -Confirm:$false
        
}

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               