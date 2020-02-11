# FileName:  ps_CreateDDLReplacementGroups_LATAMRegion.ps1
#----------------------------------------------------------------------------
# Script Name: [Create exPS groups to replace exDYN groups for IFF]
# Created: [11/29/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
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

New-EXLDistributionGroup -Name "exPS_AllGarinEmp" -DisplayName "exPS_AllGarinEmp" -Alias "exPS_AllARGAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGarinNonEmp" -DisplayName "exPS_AllGarinNonEmp" -Alias "exPS_AllARGANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllRiodeJaneiroEmp" -DisplayName "exPS_AllRiodeJaneiroEmp" -Alias "exPS_AllBRRJEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllRiodeJaneiroNonEmp" -DisplayName "exPS_AllRiodeJaneiroNonEmp" -Alias "exPS_AllBRRJNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTamboreEmp" -DisplayName "exPS_AllTamboreEmp" -Alias "exPS_AllBRTAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTamboreNonEmp" -DisplayName "exPS_AllTamboreNonEmp" -Alias "exPS_AllBRTANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTaubuteEmp" -DisplayName "exPS_AllTaubuteEmp" -Alias "exPS_AllBRTBEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTaubuteNonEmp" -DisplayName "exPS_AllTaubuteNonEmp" -Alias "exPS_AllBRTBNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBogotaEmp" -DisplayName "exPS_AllBogotaEmp" -Alias "exPS_AllCOBGEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBogotaNonEmp" -DisplayName "exPS_AllBogotaNonEmp" -Alias "exPS_AllCOBGNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTlalnepantlaEmp" -DisplayName "exPS_AllTlalnepantlaEmp" -Alias "exPS_AllMXTLEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTlalnepantlaNonEmp" -DisplayName "exPS_AllTlalnepantlaNonEmp" -Alias "exPS_AllMXTLNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               