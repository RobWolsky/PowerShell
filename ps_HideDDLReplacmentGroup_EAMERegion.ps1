# FileName:  ps_HideDDLReplacmentGroup_EAMERegion.ps1
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

Set-EXLDistributionGroup -Identity "exPS_AllDubaiEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllDubaiNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHamburgEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHamburgNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllOberhausenEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllOberhausenNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllCairoEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllCairoNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBarcelonaEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBarcelonaNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBenicarloEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBenicarloNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMadridEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMadridNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllAumont-AubracEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllAumont-AubracNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllDijonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllDijonNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGrasseEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGrasseNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllParisEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllParisNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHaverhillEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHaverhillNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllLondonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllLondonNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMilanEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMilanNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMarathonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMarathonNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHilversumEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHilversumNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTilburg-Arom HoldEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTilburg-Arom HoldNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTilburgEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTilburgNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTilburg-SSCEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTilburg-SSCNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllWarsawEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllWarsawNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMoscowEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMoscowNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllKnislingeEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllKnislingeNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMalmoEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllMalmoNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGebzeEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGebzeNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllIstanbulEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllIstanbulNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJohannesburgEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJohannesburgNonEmp" -HiddenFromAddressListsEnabled:$True


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               