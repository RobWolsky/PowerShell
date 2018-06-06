# FileName:  ps_CreateDDLReplacementGroups_NARegion.ps1
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

New-EXLDistributionGroup -Name "exPS_AllAugustaEmp" -DisplayName "exPS_AllAugustaEmp" -Alias "exPS_AllUSAGEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllAugustaNonEmp" -DisplayName "exPS_AllAugustaNonEmp" -Alias "exPS_AllUSAGNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllCarrolltonEmp" -DisplayName "exPS_AllCarrolltonEmp" -Alias "exPS_AllUSCAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllCarrolltonNonEmp" -DisplayName "exPS_AllCarrolltonNonEmp" -Alias "exPS_AllUSCANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHazletEmp" -DisplayName "exPS_AllHazletEmp" -Alias "exPS_AllUSHZEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHazletNonEmp" -DisplayName "exPS_AllHazletNonEmp" -Alias "exPS_AllUSHZNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJacksonvilleEmp" -DisplayName "exPS_AllJacksonvilleEmp" -Alias "exPS_AllUSJXEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJacksonvilleNonEmp" -DisplayName "exPS_AllJacksonvilleNonEmp" -Alias "exPS_AllUSJXNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllNew YorkEmp" -DisplayName "exPS_AllNew YorkEmp" -Alias "exPS_AllUSNYEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllNew YorkNonEmp" -DisplayName "exPS_AllNew YorkNonEmp" -Alias "exPS_AllUSNYNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllSouth BrunswickEmp" -DisplayName "exPS_AllSouth BrunswickEmp" -Alias "exPS_AllUSSBEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllSouth BrunswickNonEmp" -DisplayName "exPS_AllSouth BrunswickNonEmp" -Alias "exPS_AllUSSBNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllUnion BeachEmp" -DisplayName "exPS_AllUnion BeachEmp" -Alias "exPS_AllUSUBEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllUnion BeachNonEmp" -DisplayName "exPS_AllUnion BeachNonEmp" -Alias "exPS_AllUSUBNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               