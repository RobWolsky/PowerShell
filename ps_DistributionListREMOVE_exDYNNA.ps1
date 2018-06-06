# FileName:  ps_DistributionListREMOVE_exPSNA.ps1
#----------------------------------------------------------------------------
# Script Name: [Remove exDYN Group from corresponding All Users group]
# Created: [12/04/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@novatechgroup.onmicrosoft.com
# Requirements: 
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Create a process to duplicate DDL functionality post O365 migration
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [12/04/2017]
# Time: [15:37]
# Issue: First revision. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

Remove-EXLDistributionGroupMember -Identity "All Users Augusta (Employees Only)" -Member "exDYN_AllUSAGEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Augusta (Non-Employees Only)" -Member "exDYN_AllUSAGNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Carrollton (Employees Only)" -Member "exDYN_AllUSCAEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Carrollton (Non-Employees Only)" -Member "exDYN_AllUSCANonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Hazlet (Employees Only)" -Member "exDYN_AllUSHZEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Hazlet (Non-Employees Only)" -Member "exDYN_AllUSHZNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Jacksonville (Employees Only)" -Member "exDYN_AllUSJXEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Jacksonville (Non-Employees Only)" -Member "exDYN_AllUSJXNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users New York (Employees Only)" -Member "exDYN_AllUSNYEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users New York (Non-Employees Only)" -Member "exDYN_AllUSNYNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users South Brunswick (Employees Only)" -Member "exDYN_AllUSSBEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users South Brunswick (Non-Employees Only)" -Member "exDYN_AllUSSBNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Union Beach (Employees Only)" -Member "exDYN_AllUSUBEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Union Beach (Non-Employees Only)" -Member "exDYN_AllUSUBNonEmp" -Confirm:$False



#-----------------------------------------------------------------------------
# END OF SCRIPT: [Remove exDYN Group from corresponding All Users group]
#-----------------------------------------------------------------------------
#> 
               