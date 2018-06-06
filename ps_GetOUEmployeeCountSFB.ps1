# FileName:  ps_GetOUEmployeeCountSFB.ps1
#----------------------------------------------------------------------------
# Script Name: [Get count of employees in each EMPLOYEE OU for SFB planning]
# Created: [02/22/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: 
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Preparatio for SFB migration at IFF
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [02/22/2018]
# Time: [13:37]
# Issue: Update for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

$OUs = @()
#Populate Identity Array
$OUs = Get-EXLOrganizationalUnit -SearchText "EMPLOYEE" 

#Initialize array variable used to store records for output
	
$arrResults = @()

ForEach ($OU in $OUs)
{
		$a = Get-ADuser -Filter * -SearchBase $OU.DistinguishedName -SearchScope OneLevel  | measure | select Count
		
  #Process for output

    $objEX = New-Object -TypeName PSObject
        
    $objEX | Add-Member -MemberType NoteProperty -Name OrgUnit -Value $OU.Identity

    $objEX | Add-Member -MemberType NoteProperty -Name UserCount -Value $a.Count

    $arrResults += $objEX 

    $objEX = $null
    #>
}


$arrResults | Out-GridView

<#
#-----------------------------------------------------------------------------
# END OF SCRIPT: [Search Employee OUs and output count of users]
#-----------------------------------------------------------------------------
#>