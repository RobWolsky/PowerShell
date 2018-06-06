# FileName:  ps_CreateDDLReplacementGroups_EAMERegion.ps1
#----------------------------------------------------------------------------
# Script Name: [Create exPS groups to replace exDYN groups for IFF]
# Created: [11/29/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@novatechgroup.onmicrosoft.com
# Requirements: None
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Create a process to duplicate DDL functionality post O365 migration
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [11/29/2017]
# Time: [16:00]
# Issue: First revision. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

New-EXLDistributionGroup -Name "exPS_AllDandenongEmp" -DisplayName "exPS_AllDandenongEmp" -Alias "exPS_AllAUDNEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllDandenongNonEmp" -DisplayName "exPS_AllDandenongNonEmp" -Alias "exPS_AllAUDNNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllLane CoveEmp" -DisplayName "exPS_AllLane CoveEmp" -Alias "exPS_AllAULCEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllLane CoveNonEmp" -DisplayName "exPS_AllLane CoveNonEmp" -Alias "exPS_AllAULCNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBeijingEmp" -DisplayName "exPS_AllBeijingEmp" -Alias "exPS_AllCNBJEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBeijingNonEmp" -DisplayName "exPS_AllBeijingNonEmp" -Alias "exPS_AllCNBJNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGuangzhouEmp" -DisplayName "exPS_AllGuangzhouEmp" -Alias "exPS_AllCNGZEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGuangzhouNonEmp" -DisplayName "exPS_AllGuangzhouNonEmp" -Alias "exPS_AllCNGZNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHuangpuEmp" -DisplayName "exPS_AllHuangpuEmp" -Alias "exPS_AllCNHUEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHuangpuNonEmp" -DisplayName "exPS_AllHuangpuNonEmp" -Alias "exPS_AllCNHUNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHangzhouEmp" -DisplayName "exPS_AllHangzhouEmp" -Alias "exPS_AllCNHZEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHangzhouNonEmp" -DisplayName "exPS_AllHangzhouNonEmp" -Alias "exPS_AllCNHZNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllShanghaiEmp" -DisplayName "exPS_AllShanghaiEmp" -Alias "exPS_AllCNSHEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllShanghaiNonEmp" -DisplayName "exPS_AllShanghaiNonEmp" -Alias "exPS_AllCNSHNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllZhejiangEmp" -DisplayName "exPS_AllZhejiangEmp" -Alias "exPS_AllCNZJEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllZhejiangNonEmp" -DisplayName "exPS_AllZhejiangNonEmp" -Alias "exPS_AllCNZJNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllYunpuEmp" -DisplayName "exPS_AllYunpuEmp" -Alias "exPS_AllCNYPEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllYunpuNonEmp" -DisplayName "exPS_AllYunpuNonEmp" -Alias "exPS_AllCNYPNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllChengduEmp" -DisplayName "exPS_AllChengduEmp" -Alias "exPS_AllCNCUEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllChengduNonEmp" -DisplayName "exPS_AllChengduNonEmp" -Alias "exPS_AllCNCUNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJakartaEmp" -DisplayName "exPS_AllJakartaEmp" -Alias "exPS_AllIDJKEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJakartaNonEmp" -DisplayName "exPS_AllJakartaNonEmp" -Alias "exPS_AllIDJKNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBangaloreEmp" -DisplayName "exPS_AllBangaloreEmp" -Alias "exPS_AllINBLEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBangaloreNonEmp" -DisplayName "exPS_AllBangaloreNonEmp" -Alias "exPS_AllINBLNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllCalcuttaEmp" -DisplayName "exPS_AllCalcuttaEmp" -Alias "exPS_AllINCAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllCalcuttaNonEmp" -DisplayName "exPS_AllCalcuttaNonEmp" -Alias "exPS_AllINCANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllChennaiEmp" -DisplayName "exPS_AllChennaiEmp" -Alias "exPS_AllINCHEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllChennaiNonEmp" -DisplayName "exPS_AllChennaiNonEmp" -Alias "exPS_AllINCHNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTMDEmp" -DisplayName "exPS_AllTMDEmp" -Alias "exPS_AllTMDEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTMDNonEmp" -DisplayName "exPS_AllTMDNonEmp" -Alias "exPS_AllTMDNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGuindyEmp" -DisplayName "exPS_AllGuindyEmp" -Alias "exPS_AllINITEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGuindyNonEmp" -DisplayName "exPS_AllGuindyNonEmp" -Alias "exPS_AllINITNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllChittoorEmp" -DisplayName "exPS_AllChittoorEmp" -Alias "exPS_AllINCIEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllChittoorNonEmp" -DisplayName "exPS_AllChittoorNonEmp" -Alias "exPS_AllINCINonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllDelhiEmp" -DisplayName "exPS_AllDelhiEmp" -Alias "exPS_AllINDLEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllDelhiNonEmp" -DisplayName "exPS_AllDelhiNonEmp" -Alias "exPS_AllINDLNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJammuEmp" -DisplayName "exPS_AllJammuEmp" -Alias "exPS_AllINJKEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJammuNonEmp" -DisplayName "exPS_AllJammuNonEmp" -Alias "exPS_AllINJKNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMumbaiEmp" -DisplayName "exPS_AllMumbaiEmp" -Alias "exPS_AllINMBEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMumbaiNonEmp" -DisplayName "exPS_AllMumbaiNonEmp" -Alias "exPS_AllINMBNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGotembaEmp" -DisplayName "exPS_AllGotembaEmp" -Alias "exPS_AllJPGOEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGotembaNonEmp" -DisplayName "exPS_AllGotembaNonEmp" -Alias "exPS_AllJPGONonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTokyoEmp" -DisplayName "exPS_AllTokyoEmp" -Alias "exPS_AllJPTKEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTokyoNonEmp" -DisplayName "exPS_AllTokyoNonEmp" -Alias "exPS_AllJPTKNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllSeoulEmp" -DisplayName "exPS_AllSeoulEmp" -Alias "exPS_AllKRSEEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllSeoulNonEmp" -DisplayName "exPS_AllSeoulNonEmp" -Alias "exPS_AllKRSENonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllAucklandEmp" -DisplayName "exPS_AllAucklandEmp" -Alias "exPS_AllNZAKEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllAucklandNonEmp" -DisplayName "exPS_AllAucklandNonEmp" -Alias "exPS_AllNZAKNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllManila-OfficeEmp" -DisplayName "exPS_AllManila-OfficeEmp" -Alias "exPS_AllPHMAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllManila-OfficeNonEmp" -DisplayName "exPS_AllManila-OfficeNonEmp" -Alias "exPS_AllPHMANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllManila-PlantEmp" -DisplayName "exPS_AllManila-PlantEmp" -Alias "exPS_AllPHMBEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllManila-PlantNonEmp" -DisplayName "exPS_AllManila-PlantNonEmp" -Alias "exPS_AllPHMBNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJurongEmp" -DisplayName "exPS_AllJurongEmp" -Alias "exPS_AllSGJREmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJurongNonEmp" -DisplayName "exPS_AllJurongNonEmp" -Alias "exPS_AllSGJRNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllScience ParkEmp" -DisplayName "exPS_AllScience ParkEmp" -Alias "exPS_AllSGSGEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllScience ParkNonEmp" -DisplayName "exPS_AllScience ParkNonEmp" -Alias "exPS_AllSGSGNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBangkok-PlantEmp" -DisplayName "exPS_AllBangkok-PlantEmp" -Alias "exPS_AllTHBKEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBangkok-PlantNonEmp" -DisplayName "exPS_AllBangkok-PlantNonEmp" -Alias "exPS_AllTHBKNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBangkok-OfficeEmp" -DisplayName "exPS_AllBangkok-OfficeEmp" -Alias "exPS_AllTHBSEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBangkok-OfficeNonEmp" -DisplayName "exPS_AllBangkok-OfficeNonEmp" -Alias "exPS_AllTHBSNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               