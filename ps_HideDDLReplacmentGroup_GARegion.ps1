# FileName:  ps_HideDDLReplacmentGroup_GARegion.ps1
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

Set-EXLDistributionGroup -Identity "exPS_AllDandenongEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllDandenongNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllLane CoveEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllLane CoveNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBeijingEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBeijingNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGuangzhouEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGuangzhouNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHuangpuEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHuangpuNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHangzhouEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHangzhouNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllShanghaiEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllShanghaiNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllZhejiangEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllZhejiangNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllYunpuEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllYunpuNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllChengduEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllChengduNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJakartaEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJakartaNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBangaloreEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBangaloreNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllCalcuttaEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllCalcuttaNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllChennaiEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllChennaiNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTMDEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTMDNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGuindyEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGuindyNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllChittoorEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllChittoorNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllDelhiEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllDelhiNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJammuEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJammuNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMumbaiEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMumbaiNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGotembaEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGotembaNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTokyoEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTokyoNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllSeoulEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllSeoulNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllAucklandEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllAucklandNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllManila-OfficeEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllManila-OfficeNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllManila-PlantEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllManila-PlantNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJurongEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJurongNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllScience ParkEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllScience ParkNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBangkok-PlantEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBangkok-PlantNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBangkok-OfficeEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBangkok-OfficeNonEmp" -HiddenFromAddressListsEnabled:$True


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               