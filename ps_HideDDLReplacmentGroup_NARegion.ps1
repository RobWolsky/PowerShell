# FileName:  ps_HideDDLReplacmentGroup_NARegion.ps1
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

Set-EXLDistributionGroup -Identity "exPS_AllAugustaEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllAugustaNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllCarrolltonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllCarrolltonNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHazletEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllHazletNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJacksonvilleEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllJacksonvilleNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllNew YorkEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllNew YorkNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllSouth BrunswickEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllSouth BrunswickNonEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllUnion BeachEmp" -HiddenFromAddressListsEnabled:$True
Set-EXLDistributionGroup -Identity "exPS_AllUnion BeachNonEmp" -HiddenFromAddressListsEnabled:$True


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               