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

New-EXLDistributionGroup -Name "exPS_AllDubaiEmp" -DisplayName "exPS_AllDubaiEmp" -Alias "exPS_AllAEDUEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllDubaiNonEmp" -DisplayName "exPS_AllDubaiNonEmp" -Alias "exPS_AllAEDUNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHamburgEmp" -DisplayName "exPS_AllHamburgEmp" -Alias "exPS_AllDEHBEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHamburgNonEmp" -DisplayName "exPS_AllHamburgNonEmp" -Alias "exPS_AllDEHBNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllOberhausenEmp" -DisplayName "exPS_AllOberhausenEmp" -Alias "exPS_AllDEOBEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllOberhausenNonEmp" -DisplayName "exPS_AllOberhausenNonEmp" -Alias "exPS_AllDEOBNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllCairoEmp" -DisplayName "exPS_AllCairoEmp" -Alias "exPS_AllEGCAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllCairoNonEmp" -DisplayName "exPS_AllCairoNonEmp" -Alias "exPS_AllEGCANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBarcelonaEmp" -DisplayName "exPS_AllBarcelonaEmp" -Alias "exPS_AllESBAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBarcelonaNonEmp" -DisplayName "exPS_AllBarcelonaNonEmp" -Alias "exPS_AllESBANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBenicarloEmp" -DisplayName "exPS_AllBenicarloEmp" -Alias "exPS_AllESBEEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllBenicarloNonEmp" -DisplayName "exPS_AllBenicarloNonEmp" -Alias "exPS_AllESBENonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMadridEmp" -DisplayName "exPS_AllMadridEmp" -Alias "exPS_AllESMDEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMadridNonEmp" -DisplayName "exPS_AllMadridNonEmp" -Alias "exPS_AllESMDNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllAumont-AubracEmp" -DisplayName "exPS_AllAumont-AubracEmp" -Alias "exPS_AllFRAAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllAumont-AubracNonEmp" -DisplayName "exPS_AllAumont-AubracNonEmp" -Alias "exPS_AllFRAANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllDijonEmp" -DisplayName "exPS_AllDijonEmp" -Alias "exPS_AllFRDIEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllDijonNonEmp" -DisplayName "exPS_AllDijonNonEmp" -Alias "exPS_AllFRDINonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGrasseEmp" -DisplayName "exPS_AllGrasseEmp" -Alias "exPS_AllFRGREmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGrasseNonEmp" -DisplayName "exPS_AllGrasseNonEmp" -Alias "exPS_AllFRGRNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllParisEmp" -DisplayName "exPS_AllParisEmp" -Alias "exPS_AllFRPAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllParisNonEmp" -DisplayName "exPS_AllParisNonEmp" -Alias "exPS_AllFRPANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHaverhillEmp" -DisplayName "exPS_AllHaverhillEmp" -Alias "exPS_AllGBHHEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHaverhillNonEmp" -DisplayName "exPS_AllHaverhillNonEmp" -Alias "exPS_AllGBHHNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllLondonEmp" -DisplayName "exPS_AllLondonEmp" -Alias "exPS_AllGBLOEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllLondonNonEmp" -DisplayName "exPS_AllLondonNonEmp" -Alias "exPS_AllGBLONonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMilanEmp" -DisplayName "exPS_AllMilanEmp" -Alias "exPS_AllITMLEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMilanNonEmp" -DisplayName "exPS_AllMilanNonEmp" -Alias "exPS_AllITMLNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMarathonEmp" -DisplayName "exPS_AllMarathonEmp" -Alias "exPS_AllNLHMEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMarathonNonEmp" -DisplayName "exPS_AllMarathonNonEmp" -Alias "exPS_AllNLHMNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHilversumEmp" -DisplayName "exPS_AllHilversumEmp" -Alias "exPS_AllNLHVEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllHilversumNonEmp" -DisplayName "exPS_AllHilversumNonEmp" -Alias "exPS_AllNLHVNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTilburg-Arom HoldEmp" -DisplayName "exPS_AllTilburg-Arom HoldEmp" -Alias "exPS_AllNLTAEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTilburg-Arom HoldNonEmp" -DisplayName "exPS_AllTilburg-Arom HoldNonEmp" -Alias "exPS_AllNLTANonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTilburgEmp" -DisplayName "exPS_AllTilburgEmp" -Alias "exPS_AllNLTBEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTilburgNonEmp" -DisplayName "exPS_AllTilburgNonEmp" -Alias "exPS_AllNLTBNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTilburg-SSCEmp" -DisplayName "exPS_AllTilburg-SSCEmp" -Alias "exPS_AllNLTSEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllTilburg-SSCNonEmp" -DisplayName "exPS_AllTilburg-SSCNonEmp" -Alias "exPS_AllNLTSNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllWarsawEmp" -DisplayName "exPS_AllWarsawEmp" -Alias "exPS_AllPLWSEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllWarsawNonEmp" -DisplayName "exPS_AllWarsawNonEmp" -Alias "exPS_AllPLWSNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMoscowEmp" -DisplayName "exPS_AllMoscowEmp" -Alias "exPS_AllRUMOEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMoscowNonEmp" -DisplayName "exPS_AllMoscowNonEmp" -Alias "exPS_AllRUMONonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllKnislingeEmp" -DisplayName "exPS_AllKnislingeEmp" -Alias "exPS_AllSEKNEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllKnislingeNonEmp" -DisplayName "exPS_AllKnislingeNonEmp" -Alias "exPS_AllSEKNNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMalmoEmp" -DisplayName "exPS_AllMalmoEmp" -Alias "exPS_AllSEMMEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllMalmoNonEmp" -DisplayName "exPS_AllMalmoNonEmp" -Alias "exPS_AllSEMMNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGebzeEmp" -DisplayName "exPS_AllGebzeEmp" -Alias "exPS_AllTRGEEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllGebzeNonEmp" -DisplayName "exPS_AllGebzeNonEmp" -Alias "exPS_AllTRGENonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllIstanbulEmp" -DisplayName "exPS_AllIstanbulEmp" -Alias "exPS_AllTRISEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllIstanbulNonEmp" -DisplayName "exPS_AllIstanbulNonEmp" -Alias "exPS_AllTRISNonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJohannesburgEmp" -DisplayName "exPS_AllJohannesburgEmp" -Alias "exPS_AllZAJOEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False
New-EXLDistributionGroup -Name "exPS_AllJohannesburgNonEmp" -DisplayName "exPS_AllJohannesburgNonEmp" -Alias "exPS_AllZAJONonEmp" -OrganizationalUnit "global.iff.com/IFF/Exchange/exGroups" -ManagedBy "llm7786" -Notes "Auto populated group via Powershell script."-Confirm:$False


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               