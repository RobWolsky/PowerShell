# FileName:  ps_DistributionListREMOVE_exPSLATAM.ps1
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

Remove-EXLDistributionGroupMember -Identity "All Users Garin (Employees Only)" -Member "exDYN_AllARGAEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Garin(Non-Employees Only)" -Member "exDYN_AllARGANonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Rio de Janeiro (Employees Only)" -Member "exDYN_AllBRRJEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Rio de Janeiro (Non-Employees Only)" -Member "exDYN_AllBRRJNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Tambore (Employees Only)" -Member "exDYN_AllBRTAEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Tambore (Non-Employees Only)" -Member "exDYN_AllBRTANonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Taubute (Employees Only)" -Member "exDYN_AllBRTBEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Taubute (Non-Employees Only)" -Member "exDYN_AllBRTBNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Bogota (Employees Only)" -Member "exDYN_AllCOBGEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Bogota (Non-Employees Only)" -Member "exDYN_AllCOBGNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Tlalnepantla (Employees Only)" -Member "exDYN_AllMXTLEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Tlalnepantla (Non-Employees Only)" -Member "exDYN_AllMXTLNonEmp" -Confirm:$False


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Remove exDYN Group from corresponding All Users group]
#-----------------------------------------------------------------------------
#> 
               