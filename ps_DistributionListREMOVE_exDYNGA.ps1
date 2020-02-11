# FileName:  ps_DistributionListREMOVE_exDYNGA.ps1
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

#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllAUDNEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "" -Member "exDYN_AllAUDNNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Lane Cove (Employees Only)" -Member "exDYN_AllAULCEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Lane Cove (Non-Employees Only)" -Member "exDYN_AllAULCNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Beijing (Employees Only)" -Member "exDYN_AllCNBJEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Beijing (Non-Employees Only)" -Member "exDYN_AllCNBJNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Guangzhou (Employees Only)" -Member "exDYN_AllCNGZEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Guangzhou (Non-Employees Only)" -Member "exDYN_AllCNGZNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Huangpu (Employees Only)" -Member "exDYN_AllCNHUEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Huangpu (Non-Employees Only)" -Member "exDYN_AllCNHUNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Hangzhou (Employees Only)" -Member "exDYN_AllCNHZEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Hangzhou (Non-Employees Only)" -Member "exDYN_AllCNHZNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Shanghai (Employees Only)" -Member "exDYN_AllCNSHEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Shanghai (Non-Employees Only)" -Member "exDYN_AllCNSHNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Zhejiang (Employees Only)" -Member "exDYN_AllCNZJEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Zhejiang (Non-Employees Only)" -Member "exDYN_AllCNZJNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Yunpu (Employees Only)" -Member "exDYN_AllCNYPEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Yunpu (Non-Employees Only)" -Member "exDYN_AllCNYPNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Chengdu (Employees Only)" -Member "exDYN_AllCNCUEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Chengdu (Non-Employees Only)" -Member "exDYN_AllCNCUNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Jakarta (Employees Only)" -Member "exDYN_AllIDJKEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Jakarta (Non-Employees Only)" -Member "exDYN_AllIDJKNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Bangalore (Employees Only)" -Member "exDYN_AllINBLEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Bangalore (Non-Employees Only)" -Member "exDYN_AllINBLNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Calcutta (Employees Only)" -Member "exDYN_AllINCAEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Calcutta (Non-Employees Only)" -Member "exDYN_AllINCANonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Chennai (Employees Only)" -Member "exDYN_AllINCHEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Chennai (Non-Employees Only)" -Member "exDYN_AllINCHNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users TMD (Employees Only)" -Member "exDYN_AllTMDEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users TMD (Non-Employees Only)" -Member "exDYN_AllTMDNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Guindy (Employees Only)" -Member "exDYN_AllINITEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Guindy (Non-Employees Only)" -Member "exDYN_AllINITNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Chittoor (Employees Only)" -Member "exDYN_AllINCIEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Chittoor (Non-Employees Only)" -Member "exDYN_AllINCINonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Delhi (Employees Only)" -Member "exDYN_AllINDLEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Delhi (Non-Employees Only)" -Member "exDYN_AllINDLNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Jammu (Employees Only)" -Member "exDYN_AllINJKEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Jammu (Non-Employees Only)" -Member "exDYN_AllINJKNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Mumbai (Employees Only)" -Member "exDYN_AllINMBEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Mumbai (Non-Employees Only)" -Member "exDYN_AllINMBNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Gotemba (Employees Only)" -Member "exDYN_AllJPGOEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Gotemba (Non-Employees Only)" -Member "exDYN_AllJPGONonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Tokyo (Employees Only)" -Member "exDYN_AllJPTKEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Tokyo (Non-Employees Only)" -Member "exDYN_AllJPTKNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Seoul (Employees Only)" -Member "exDYN_AllKRSEEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Seoul (Non-Employees Only)" -Member "exDYN_AllKRSENonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Auckland (Employees Only)" -Member "exDYN_AllNZAKEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Auckland (Non-Employees Only)" -Member "exDYN_AllNZAKNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Manila-Office (Employees Only)" -Member "exDYN_AllPHMAEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Manila-Office (Non-Employees Only)" -Member "exDYN_AllPHMANonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Manila-Plant (Employees Only)" -Member "exDYN_AllPHMBEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Manila-Plant (Non-Employees Only)" -Member "exDYN_AllPHMBNonEmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Jurong (Employees Only)" -Member "exDYN_AllSGJREmp" -Confirm:$False
Remove-EXLDistributionGroupMember -Identity "All Users Jurong (Non-Employees Only)" -Member "exDYN_AllSGJRNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Science Park (Employees Only)" -Member "exDYN_AllSGSGEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Science Park (Non-Employees Only)" -Member "exDYN_AllSGSGNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Bangkok (Employees Only)" -Member "exDYN_AllTHBKEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Bangkok (Non-Employees Only)" -Member "exDYN_AllTHBKNonEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Bangkok Office (Employees Only)" -Member "exDYN_AllTHBSEmp" -Confirm:$False
#Remove-EXLDistributionGroupMember -Identity "All Users Bangkok Office (Non-Employees Only)" -Member "exDYN_AllTHBSNonEmp" -Confirm:$False


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Remove exDYN Group from corresponding All Users group]
#-----------------------------------------------------------------------------
#> 
               