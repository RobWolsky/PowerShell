# FileName:  ps_DistributionListUpdate.ps1
#----------------------------------------------------------------------------
# Script Name: [Update Distribution Lists from OU, replace DDL function]
# Created: [11/06/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@novatechgroup.onmicrosoft.com
# Requirements: OU and Distribution Group pairs are embedded in the script
# Requirements: These must be updated as required to reflect changes in AD
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Create a process to duplicate DDL functionality post O365 migration
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [11/06/2017]
# Time: [09:29]
# Issue: First revision. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

#Initialize Hash Table to store OU/Distribution Group input pairs
$OUandGROUP = @{}

#Populate Hash Table with OU's and target Distribution Groups

$OUandGROUP.Add("global.iff.com/IFF/GA/AU/DN/EMPLOYEE", "exPS_AllDandenongEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/AU/DN/NONEMPLOYEES", "exPS_AllDandenongNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/AU/LC/EMPLOYEE", "exPS_AllLane CoveEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/AU/LC/NONEMPLOYEES", "exPS_AllLane CoveNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/BJ/EMPLOYEE", "exPS_AllBeijingEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/BJ/NONEMPLOYEES", "exPS_AllBeijingNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/GZ/EMPLOYEE", "exPS_AllGuangzhouEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/GZ/NONEMPLOYEES", "exPS_AllGuangzhouNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/HU/EMPLOYEE", "exPS_AllHuangpuEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/HU/NONEMPLOYEES", "exPS_AllHuangpuNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/HZ/EMPLOYEE", "exPS_AllHangzhouEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/HZ/NONEMPLOYEES", "exPS_AllHangzhouNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/SH/EMPLOYEE", "exPS_AllShanghaiEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/SH/NONEMPLOYEES", "exPS_AllShanghaiNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/ZJ/EMPLOYEE", "exPS_AllZhejiangEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/ZJ/NONEMPLOYEES", "exPS_AllZhejiangNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/YP/EMPLOYEE", "exPS_AllYunpuEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/YP/NONEMPLOYEES", "exPS_AllYunpuNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/CU/EMPLOYEE", "exPS_AllChengduEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/CN/CU/NONEMPLOYEES", "exPS_AllChengduNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/ID/JK/EMPLOYEE", "exPS_AllJakartaEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/ID/JK/NONEMPLOYEES", "exPS_AllJakartaNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/BL/EMPLOYEE", "exPS_AllBangaloreEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/BL/NONEMPLOYEES", "exPS_AllBangaloreNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/CA/EMPLOYEE", "exPS_AllCalcuttaEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/CA/NONEMPLOYEES", "exPS_AllCalcuttaNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/CH/EMPLOYEE", "exPS_AllChennaiEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/CH/NONEMPLOYEES", "exPS_AllChennaiNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/CF/EMPLOYEE", "exPS_AllTMDEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/CF/NONEMPLOYEES", "exPS_AllTMDNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/IT/EMPLOYEE", "exPS_AllGuindyEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/IT/NONEMPLOYEES", "exPS_AllGuindyNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/CI/EMPLOYEE", "exPS_AllChittoorEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/CI/NONEMPLOYEES", "exPS_AllChittoorNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/DL/EMPLOYEE", "exPS_AllDelhiEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/DL/NONEMPLOYEES", "exPS_AllDelhiNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/JK/EMPLOYEE", "exPS_AllJammuEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/JK/NONEMPLOYEES", "exPS_AllJammuNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/MB/EMPLOYEE", "exPS_AllMumbaiEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/IN/MB/NONEMPLOYEES", "exPS_AllMumbaiNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/JP/GO/EMPLOYEE", "exPS_AllGotembaEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/JP/GO/NONEMPLOYEES", "exPS_AllGotembaNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/JP/TK/EMPLOYEE", "exPS_AllTokyoEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/JP/TK/NONEMPLOYEES", "exPS_AllTokyoNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/KR/SE/EMPLOYEE", "exPS_AllSeoulEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/KR/SE/NONEMPLOYEES", "exPS_AllSeoulNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/NZ/AK/EMPLOYEE", "exPS_AllAucklandEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/NZ/AK/NONEMPLOYEES", "exPS_AllAucklandNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/PH/MA/EMPLOYEE", "exPS_AllManila-OfficeEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/PH/MA/NONEMPLOYEES", "exPS_AllManila-OfficeNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/PH/MB/EMPLOYEE", "exPS_AllManila-PlantEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/PH/MB/NONEMPLOYEES", "exPS_AllManila-PlantNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/SG/JR/EMPLOYEE", "exPS_AllJurongEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/SG/JR/NONEMPLOYEES", "exPS_AllJurongNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/SG/SG/EMPLOYEE", "exPS_AllScience ParkEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/SG/SG/NONEMPLOYEES", "exPS_AllScience ParkNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/TH/BK/EMPLOYEE", "exPS_AllBangkok-PlantEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/TH/BK/NONEMPLOYEES", "exPS_AllBangkok-PlantNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/TH/BS/EMPLOYEE", "exPS_AllBangkok-OfficeEmp")
$OUandGROUP.Add("global.iff.com/IFF/GA/TH/BS/NONEMPLOYEES", "exPS_AllBangkok-OfficeNonEmp")
#>

#Enumerate Hash Table and update group memberships

$OUandGROUP.GetEnumerator() | ForEach-Object{
        $OU = $_.Key
        $GROUP = $_.Value
        $message = 'OU {0} users will be added to Group: {1}' -f $OU, $GROUP
        Write-Host $message -fore gray -back red
        $a = Get-EXLRecipient -RecipientType MailUser, UserMailbox -OrganizationalUnit $OU | Select Name, SamAccountName, PrimarySMTPAddress, RecipientType, OrganizationalUnit
        Update-EXLDistributionGroupMember -DomainController usbodcpv3 -Identity $GROUP -Members $a.PrimarySMTPAddress -Confirm:$false
        
}

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               