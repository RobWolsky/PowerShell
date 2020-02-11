# FileName:  ps_DistributionListREMOVE_exDYNEAME.ps1
#----------------------------------------------------------------------------
# Script Name: [Remove exDYN Group from corresponding All Users group]
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

Remove-EXLDistributionGroupMember -Identity "All Users Dubai (Employees Only)" -Member "exDYN_AllAEDUEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Dubai (Non-Employees Only)" -Member "exDYN_AllAEDUNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Hamburg (Employees Only)" -Member "exDYN_AllDEHBEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Hamburg (Non-Employees Only)" -Member "exDYN_AllDEHBNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Oberhausen (Employees Only)" -Member "exDYN_AllDEOBEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Oberhausen (Non-Employees Only)" -Member "exDYN_AllDEOBNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Cairo (Employees Only)" -Member "exDYN_AllEGCAEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Cairo (Non-Employees Only)" -Member "exDYN_AllEGCANonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Barcelona (Employees Only)" -Member "exDYN_AllESBAEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Barcelona (Non-Employees Only)" -Member "exDYN_AllESBANonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Benicarlo (Employees Only)" -Member "exDYN_AllESBEEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Benicarlo (Non-Employees Only)" -Member "exDYN_AllESBENonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Madrid (Employees Only)" -Member "exDYN_AllESMDEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Madrid (Non-Employees Only)" -Member "exDYN_AllESMDNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Aumont-Aubrac (Employees Only)" -Member "exDYN_AllFRAAEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Aumont-Aubrac (Non-Employees Only)" -Member "exDYN_AllFRAANonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Dijon (Employees Only)" -Member "exDYN_AllFRDIEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Dijon (Non-Employees Only)" -Member "exDYN_AllFRDINonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Grasse (Employees Only)" -Member "exDYN_AllFRGREmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Grasse (Non-Employees Only)" -Member "exDYN_AllFRGRNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Paris (Employees Only)" -Member "exDYN_AllFRPAEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Paris (Non-Employees Only)" -Member "exDYN_AllFRPANonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllGBHHEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllGBHHNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllGBLOEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllGBLONonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Milan (Employees Only)" -Member "exDYN_AllITMLEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Milan (Non-Employees Only)" -Member "exDYN_AllITMLNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Marathon (Employees Only)" -Member "exDYN_AllNLHMEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Marathon (Non-Employees Only)" -Member "exDYN_AllNLHMNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllNLHVEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllNLHVNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllNLTAEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllNLTANonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllNLTBEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllNLTBNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllNLTSEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllNLTSNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllPLWSEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllPLWSNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllRUMOEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllRUMONonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllSEKNEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllSEKNNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllSEMMEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllSEMMNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllTRGEEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllTRGENonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllTRISEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllTRISNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllZAJOEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllZAJONonEmp" -Confirm:$False


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Remove exDYN Group from corresponding All Users group]
#-----------------------------------------------------------------------------
#> 
               