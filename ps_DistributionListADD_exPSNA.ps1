# FileName:  ps_DistributionListADD_exPSNA.ps1
#----------------------------------------------------------------------------
# Script Name: [Add exPS Group to corresponding All Users group]
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

Add-EXLDistributionGroupMember -Identity "All Users Augusta (Employees Only)" -Member "exPS_AllUSAGEmp"
Add-EXLDistributionGroupMember -Identity "All Users Augusta (Non-Employees Only)" -Member "exPS_AllUSAGNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Carrollton (Employees Only)" -Member "exPS_AllUSCAEmp"
Add-EXLDistributionGroupMember -Identity "All Users Carrollton (Non-Employees Only)" -Member "exPS_AllUSCANonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Hazlet (Employees Only)" -Member "exPS_AllUSHZEmp"
Add-EXLDistributionGroupMember -Identity "All Users Hazlet (Non-Employees Only)" -Member "exPS_AllUSHZNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Jacksonville (Employees Only)" -Member "exPS_AllUSJXEmp"
Add-EXLDistributionGroupMember -Identity "All Users Jacksonville (Non-Employees Only)" -Member "exPS_AllUSJXNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users New York (Employees Only)" -Member "exPS_AllUSNYEmp"
Add-EXLDistributionGroupMember -Identity "All Users New York (Non-Employees Only)" -Member "exPS_AllUSNYNonEmp"
#Add-EXLDistributionGroupMember -Identity "All Users South Brunswick (Employees Only)" -Member "exPS_AllUSSBEmp"
Add-EXLDistributionGroupMember -Identity "All Users South Brunswick (Non-Employees Only)" -Member "exPS_AllUSSBNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Union Beach (Employees Only)" -Member "exPS_AllUSUBEmp"
Add-EXLDistributionGroupMember -Identity "All Users Union Beach (Non-Employees Only)" -Member "exPS_AllUSUBNonEmp"


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Add exPS Group to corresponding All Users group]
#-----------------------------------------------------------------------------
#> 
               