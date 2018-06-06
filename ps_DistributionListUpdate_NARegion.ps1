# FileName:  ps_DistributionListUpdate.ps1
#----------------------------------------------------------------------------
# Script Name: [Update Distribution Lists from OU, replace DDL function]
# Created: [11/06/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@novatechgroup.onmicrosoft.com
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
$OUandGROUP.Add("global.iff.com/IFF/NA/US/AG/EMPLOYEE", "exPS_AllAugustaEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/AG/NONEMPLOYEES", "exPS_AllAugustaNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/CA/EMPLOYEE", "exPS_AllCarrolltonEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/CA/NONEMPLOYEES", "exPS_AllCarrolltonNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/HZ/EMPLOYEE", "exPS_AllHazletEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/HZ/NONEMPLOYEES", "exPS_AllHazletNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/JX/EMPLOYEE", "exPS_AllJacksonvilleEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/JX/NONEMPLOYEES", "exPS_AllJacksonvilleNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/NY/EMPLOYEE", "exPS_AllNew YorkEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/NY/NONEMPLOYEES", "exPS_AllNew YorkNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/SB/EMPLOYEE", "exPS_AllSouth BrunswickEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/SB/NONEMPLOYEES", "exPS_AllSouth BrunswickNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/UB/EMPLOYEE", "exPS_AllUnion BeachEmp")
$OUandGROUP.Add("global.iff.com/IFF/NA/US/UB/NONEMPLOYEES", "exPS_AllUnion BeachNonEmp")


#Enumerate Hash Table and update group memberships

$OUandGROUP.GetEnumerator() | ForEach-Object{
        $OU = $_.Key
        $GROUP = $_.Value
        $message = 'OU {0} users will be added to Group: {1}' -f $OU, $GROUP
        Write-Host $message -fore gray -back red
        $a = Get-EXLRecipient -RecipientType MailUser, UserMailbox -OrganizationalUnit $OU | Select Name, SamAccountName, PrimarySMTPAddress, RecipientType, OrganizationalUnit
        Update-EXLDistributionGroupMember -Identity $GROUP -Members $a.PrimarySMTPAddress -Confirm:$false
        
}

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               