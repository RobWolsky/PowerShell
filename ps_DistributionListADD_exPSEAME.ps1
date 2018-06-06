# FileName:  ps_DistributionListADD_exPSEAME.ps1
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

Add-EXLDistributionGroupMember -Identity "All Users Dubai (Employees Only)" -Member "exPS_AllAEDUEmp"
Add-EXLDistributionGroupMember -Identity "All Users Dubai (Non-Employees Only)" -Member "exPS_AllAEDUNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Hamburg (Employees Only)" -Member "exPS_AllDEHBEmp"
Add-EXLDistributionGroupMember -Identity "All Users Hamburg (Non-Employees Only)" -Member "exPS_AllDEHBNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Oberhausen (Employees Only)" -Member "exPS_AllDEOBEmp"
Add-EXLDistributionGroupMember -Identity "All Users Oberhausen (Non-Employees Only)" -Member "exPS_AllDEOBNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Cairo (Employees Only)" -Member "exPS_AllEGCAEmp"
Add-EXLDistributionGroupMember -Identity "All Users Cairo (Non-Employees Only)" -Member "exPS_AllEGCANonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Barcelona (Employees Only)" -Member "exPS_AllESBAEmp"
Add-EXLDistributionGroupMember -Identity "All Users Barcelona (Non-Employees Only)" -Member "exPS_AllESBANonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Benicarlo (Employees Only)" -Member "exPS_AllESBEEmp"
Add-EXLDistributionGroupMember -Identity "All Users Benicarlo (Non-Employees Only)" -Member "exPS_AllESBENonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Madrid (Employees Only)" -Member "exPS_AllESMDEmp"
Add-EXLDistributionGroupMember -Identity "All Users Madrid (Non-Employees Only)" -Member "exPS_AllESMDNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Aumont-Aubrac (Employees Only)" -Member "exPS_AllFRAAEmp"
Add-EXLDistributionGroupMember -Identity "All Users Aumont-Aubrac (Non-Employees Only)" -Member "exPS_AllFRAANonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Dijon (Employees Only)" -Member "exPS_AllFRDIEmp"
Add-EXLDistributionGroupMember -Identity "All Users Dijon (Non-Employees Only)" -Member "exPS_AllFRDINonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Grasse (Employees Only)" -Member "exPS_AllFRGREmp"
Add-EXLDistributionGroupMember -Identity "All Users Grasse (Non-Employees Only)" -Member "exPS_AllFRGRNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Paris (Employees Only)" -Member "exPS_AllFRPAEmp"
Add-EXLDistributionGroupMember -Identity "All Users Paris (Non-Employees Only)" -Member "exPS_AllFRPANonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllGBHHEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllGBHHNonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllGBLOEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllGBLONonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Milan (Employees Only)" -Member "exPS_AllITMLEmp"
Add-EXLDistributionGroupMember -Identity "All Users Milan (Non-Employees Only)" -Member "exPS_AllITMLNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Marathon (Employees Only)" -Member "exPS_AllNLHMEmp"
Add-EXLDistributionGroupMember -Identity "All Users Marathon (Non-Employees Only)" -Member "exPS_AllNLHMNonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllNLHVEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllNLHVNonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllNLTAEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllNLTANonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllNLTBEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllNLTBNonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllNLTSEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllNLTSNonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllPLWSEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllPLWSNonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllRUMOEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllRUMONonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllSEKNEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllSEKNNonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllSEMMEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllSEMMNonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllTRGEEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllTRGENonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllTRISEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllTRISNonEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllZAJOEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllZAJONonEmp"



#-----------------------------------------------------------------------------
# END OF SCRIPT: [Add exPS Group to corresponding All Users group]
#-----------------------------------------------------------------------------
#> 
               