# FileName:  ps_HideDDLReplacmentGroup_LATAMRegion.ps1
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

Set-EXLDistributionGroup -Identity "exPS_AllGarinEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllGarinNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllRiodeJaneiroEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllRiodeJaneiroNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTamboreEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTamboreNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTaubuteEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTaubuteNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBogotaEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllBogotaNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTlalnepantlaEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllTlalnepantlaNonEmp" -HiddenFromAddressListsEnabled:$True


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               