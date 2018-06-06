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
$OUandGROUP.Add("global.iff.com/IFF/EAME/AE/DU/EMPLOYEE", "exPS_AllDubaiEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/AE/DU/NONEMPLOYEES", "exPS_AllDubaiNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/DE/HB/EMPLOYEE", "exPS_AllHamburgEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/DE/HB/NONEMPLOYEES", "exPS_AllHamburgNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/DE/OB/EMPLOYEE", "exPS_AllOberhausenEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/DE/OB/NONEMPLOYEES", "exPS_AllOberhausenNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/EG/CA/EMPLOYEE", "exPS_AllCairoEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/EG/CA/NONEMPLOYEES", "exPS_AllCairoNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/ES/BA/EMPLOYEE", "exPS_AllBarcelonaEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/ES/BA/NONEMPLOYEES", "exPS_AllBarcelonaNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/ES/BE/EMPLOYEE", "exPS_AllBenicarloEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/ES/BE/NONEMPLOYEES", "exPS_AllBenicarloNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/ES/MD/EMPLOYEE", "exPS_AllMadridEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/ES/MD/NONEMPLOYEES", "exPS_AllMadridNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/FR/AA/EMPLOYEE", "exPS_AllAumont-AubracEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/FR/AA/NONEMPLOYEES", "exPS_AllAumont-AubracNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/FR/DI/EMPLOYEE", "exPS_AllDijonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/FR/DI/NONEMPLOYEES", "exPS_AllDijonNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/FR/GR/EMPLOYEE", "exPS_AllGrasseEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/FR/GR/NONEMPLOYEES", "exPS_AllGrasseNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/FR/PA/EMPLOYEE", "exPS_AllParisEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/FR/PA/NONEMPLOYEES", "exPS_AllParisNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/GB/HH/EMPLOYEE", "exPS_AllHaverhillEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/GB/HH/NONEMPLOYEES", "exPS_AllHaverhillNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/GB/LO/EMPLOYEE", "exPS_AllLondonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/GB/LO/NONEMPLOYEES", "exPS_AllLondonNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/IT/ML/EMPLOYEE", "exPS_AllMilanEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/IT/ML/NONEMPLOYEES", "exPS_AllMilanNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/HM/EMPLOYEE", "exPS_AllMarathonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/HM/NONEMPLOYEES", "exPS_AllMarathonNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/HV/EMPLOYEE", "exPS_AllHilversumEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/HV/NONEMPLOYEES", "exPS_AllHilversumNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/TA/EMPLOYEE", "exPS_AllTilburg-Arom HoldEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/TA/NONEMPLOYEES", "exPS_AllTilburg-Arom HoldNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/TB/EMPLOYEE", "exPS_AllTilburgEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/TB/NONEMPLOYEES", "exPS_AllTilburgNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/TS/EMPLOYEE", "exPS_AllTilburg-SSCEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/NL/TS/NONEMPLOYEES", "exPS_AllTilburg-SSCNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/PL/WS/EMPLOYEE", "exPS_AllWarsawEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/PL/WS/NONEMPLOYEES", "exPS_AllWarsawNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/RU/MO/EMPLOYEE", "exPS_AllMoscowEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/RU/MO/NONEMPLOYEES", "exPS_AllMoscowNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/SE/KN/EMPLOYEE", "exPS_AllKnislingeEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/SE/KN/NONEMPLOYEES", "exPS_AllKnislingeNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/SE/MM/EMPLOYEE", "exPS_AllMalmoEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/SE/MM/NONEMPLOYEES", "exPS_AllMalmoNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/TR/GE/EMPLOYEE", "exPS_AllGebzeEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/TR/GE/NONEMPLOYEES", "exPS_AllGebzeNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/TR/IS/EMPLOYEE", "exPS_AllIstanbulEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/TR/IS/NONEMPLOYEES", "exPS_AllIstanbulNonEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/ZA/JO/EMPLOYEE", "exPS_AllJohannesburgEmp")
$OUandGROUP.Add("global.iff.com/IFF/EAME/ZA/JO/NONEMPLOYEES", "exPS_AllJohannesburgNonEmp")



#Enumerate Hash Table and update group memberships

$OUandGROUP.GetEnumerator() | ForEach-Object{
        $OU = $_.Key
        $GROUP = $_.Value
        $message = 'OU {0} users will be added to Group: {1}' -f $OU, $GROUP
        Write-Host $message -fore gray -back red
        $a = Get-EXLRecipient -RecipientType MailUser, UserMailbox -OrganizationalUnit $OU | Select Name, SamAccountName, PrimarySMTPAddress, RecipientType, OrganizationalUnit
        Update-EXLDistributionGroupMember -Identity $GROUP -Members $a.PrimarySMTPAddress -Confirm:$false
        
}

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Update Distribution Lists from OU, replace DDL function]
#-----------------------------------------------------------------------------
#> 
               