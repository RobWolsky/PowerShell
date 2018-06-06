# FileName:  ps_DistributionListADD_exPSGA.ps1
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

#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllAUDNEmp"
#Add-EXLDistributionGroupMember -Identity "" -Member "exPS_AllAUDNNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Lane Cove (Employees Only)" -Member "exPS_AllAULCEmp"
Add-EXLDistributionGroupMember -Identity "All Users Lane Cove (Non-Employees Only)" -Member "exPS_AllAULCNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Beijing (Employees Only)" -Member "exPS_AllCNBJEmp"
Add-EXLDistributionGroupMember -Identity "All Users Beijing (Non-Employees Only)" -Member "exPS_AllCNBJNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Guangzhou (Employees Only)" -Member "exPS_AllCNGZEmp"
Add-EXLDistributionGroupMember -Identity "All Users Guangzhou (Non-Employees Only)" -Member "exPS_AllCNGZNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Huangpu (Employees Only)" -Member "exPS_AllCNHUEmp"
Add-EXLDistributionGroupMember -Identity "All Users Huangpu (Non-Employees Only)" -Member "exPS_AllCNHUNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Hangzhou (Employees Only)" -Member "exPS_AllCNHZEmp"
Add-EXLDistributionGroupMember -Identity "All Users Hangzhou (Non-Employees Only)" -Member "exPS_AllCNHZNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Shanghai (Employees Only)" -Member "exPS_AllCNSHEmp"
Add-EXLDistributionGroupMember -Identity "All Users Shanghai (Non-Employees Only)" -Member "exPS_AllCNSHNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Zhejiang (Employees Only)" -Member "exPS_AllCNZJEmp"
Add-EXLDistributionGroupMember -Identity "All Users Zhejiang (Non-Employees Only)" -Member "exPS_AllCNZJNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Yunpu (Employees Only)" -Member "exPS_AllCNYPEmp"
Add-EXLDistributionGroupMember -Identity "All Users Yunpu (Non-Employees Only)" -Member "exPS_AllCNYPNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Chengdu (Employees Only)" -Member "exPS_AllCNCUEmp"
Add-EXLDistributionGroupMember -Identity "All Users Chengdu (Non-Employees Only)" -Member "exPS_AllCNCUNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Jakarta (Employees Only)" -Member "exPS_AllIDJKEmp"
Add-EXLDistributionGroupMember -Identity "All Users Jakarta (Non-Employees Only)" -Member "exPS_AllIDJKNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Bangalore (Employees Only)" -Member "exPS_AllINBLEmp"
Add-EXLDistributionGroupMember -Identity "All Users Bangalore (Non-Employees Only)" -Member "exPS_AllINBLNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Calcutta (Employees Only)" -Member "exPS_AllINCAEmp"
Add-EXLDistributionGroupMember -Identity "All Users Calcutta (Non-Employees Only)" -Member "exPS_AllINCANonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Chennai (Employees Only)" -Member "exPS_AllINCHEmp"
Add-EXLDistributionGroupMember -Identity "All Users Chennai (Non-Employees Only)" -Member "exPS_AllINCHNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users TMD (Employees Only)" -Member "exPS_AllTMDEmp"
Add-EXLDistributionGroupMember -Identity "All Users TMD (Non-Employees Only)" -Member "exPS_AllTMDNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Guindy (Employees Only)" -Member "exPS_AllINITEmp"
Add-EXLDistributionGroupMember -Identity "All Users Guindy (Non-Employees Only)" -Member "exPS_AllINITNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Chittoor (Employees Only)" -Member "exPS_AllINCIEmp"
Add-EXLDistributionGroupMember -Identity "All Users Chittoor (Non-Employees Only)" -Member "exPS_AllINCINonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Delhi (Employees Only)" -Member "exPS_AllINDLEmp"
Add-EXLDistributionGroupMember -Identity "All Users Delhi (Non-Employees Only)" -Member "exPS_AllINDLNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Jammu (Employees Only)" -Member "exPS_AllINJKEmp"
#Add-EXLDistributionGroupMember -Identity "All Users Jammu (Non-Employees Only)" -Member "exPS_AllINJKNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Mumbai (Employees Only)" -Member "exPS_AllINMBEmp"
Add-EXLDistributionGroupMember -Identity "All Users Mumbai (Non-Employees Only)" -Member "exPS_AllINMBNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Gotemba (Employees Only)" -Member "exPS_AllJPGOEmp"
Add-EXLDistributionGroupMember -Identity "All Users Gotemba (Non-Employees Only)" -Member "exPS_AllJPGONonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Tokyo (Employees Only)" -Member "exPS_AllJPTKEmp"
Add-EXLDistributionGroupMember -Identity "All Users Tokyo (Non-Employees Only)" -Member "exPS_AllJPTKNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Seoul (Employees Only)" -Member "exPS_AllKRSEEmp"
Add-EXLDistributionGroupMember -Identity "All Users Seoul (Non-Employees Only)" -Member "exPS_AllKRSENonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Auckland (Employees Only)" -Member "exPS_AllNZAKEmp"
Add-EXLDistributionGroupMember -Identity "All Users Auckland (Non-Employees Only)" -Member "exPS_AllNZAKNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Manila-Office (Employees Only)" -Member "exPS_AllPHMAEmp"
Add-EXLDistributionGroupMember -Identity "All Users Manila-Office (Non-Employees Only)" -Member "exPS_AllPHMANonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Manila-Plant (Employees Only)" -Member "exPS_AllPHMBEmp"
Add-EXLDistributionGroupMember -Identity "All Users Manila-Plant (Non-Employees Only)" -Member "exPS_AllPHMBNonEmp"
Add-EXLDistributionGroupMember -Identity "All Users Jurong (Employees Only)" -Member "exPS_AllSGJREmp"
Add-EXLDistributionGroupMember -Identity "All Users Jurong (Non-Employees Only)" -Member "exPS_AllSGJRNonEmp"
# Security Group Add-EXLDistributionGroupMember -Identity "All Users Science Park (Employees Only)" -Member "exPS_AllSGSGEmp"
# Security Group Add-EXLDistributionGroupMember -Identity "All Users Science Park (Non-Employees Only)" -Member "exPS_AllSGSGNonEmp"
#Add-EXLDistributionGroupMember -Identity "All Users Bangkok (Employees Only)" -Member "exPS_AllTHBKEmp"
#Add-EXLDistributionGroupMember -Identity "All Users Bangkok (Non-Employees Only)" -Member "exPS_AllTHBKNonEmp"
#Add-EXLDistributionGroupMember -Identity "All Users Bangkok Office (Employees Only)" -Member "exPS_AllTHBSEmp"
#Add-EXLDistributionGroupMember -Identity "All Users Bangkok Office (Non-Employees Only)" -Member "exPS_AllTHBSNonEmp"



#-----------------------------------------------------------------------------
# END OF SCRIPT: [Add exPS Group to corresponding All Users group]
#-----------------------------------------------------------------------------
#> 
               