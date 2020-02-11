# FileName:  ps_DistributionListADD_exPSLATAM.ps1
#----------------------------------------------------------------------------
# Script Name: [Add exPS Group to corresponding All Users group]
# Created: [12/04/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
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

Add-EXLDistributionGroupMember -Identity "All Users Garin (Employees Only)" -Member "exPS_AllARGAEmp"
#Add-EXLDistributionGroupMember -Identity "All Users Garin(Non-Employees Only)" -Member "exPS_AllARGANonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Rio de Janeiro (Employees Only)" -Member "exPS_AllBRRJEmp"
Add-EXLDistributionGroupMember -Identity "All Users Rio de Janeiro (Non-Employees Only)" -Member "exPS_AllBRRJNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Tambore (Employees Only)" -Member "exPS_AllBRTAEmp"
Add-EXLDistributionGroupMember -Identity "All Users Tambore (Non-Employees Only)" -Member "exPS_AllBRTANonEmp"
#Add-EXLDistributionGroupMember -Identity "All Users Taubute (Employees Only)" -Member "exPS_AllBRTBEmp"
#Add-EXLDistributionGroupMember -Identity "All Users Taubute (Non-Employees Only)" -Member "exPS_AllBRTBNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Bogota (Employees Only)" -Member "exPS_AllCOBGEmp"
Add-EXLDistributionGroupMember -Identity "All Users Bogota (Non-Employees Only)" -Member "exPS_AllCOBGNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Tlalnepantla (Employees Only)" -Member "exPS_AllMXTLEmp"
Add-EXLDistributionGroupMember -Identity "All Users Tlalnepantla (Non-Employees Only)" -Member "exPS_AllMXTLNonEmp"



#-----------------------------------------------------------------------------
# END OF SCRIPT: [Add exPS Group to corresponding All Users group]
#-----------------------------------------------------------------------------
#> 
               