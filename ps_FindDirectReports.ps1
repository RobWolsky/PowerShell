# FileName:  ps_FindDirectReportsforVIPs.ps1
#----------------------------------------------------------------------------
# Script Name: [Input a list of VIP's, find all direct reports]
# Created: [03/27/2018]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: CSV file containing VIP SamAccountName 
# Requirements: List relevant identities in c:\Temp\upn_batch.csv (header Name)
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Find VIP direct reports to look for admins and delegates
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [03/27/2018]
# Time: [13:47]
# Issue: Update for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

$identities = @()
#Populate Identity Array
[Array] $identities = Import-Csv C:\temp\upn_batch.csv

#Initialize array variable used to store records for output

Write-Host -ForegroundColor Green "Processing user objects."
Write-Host -ForegroundColor Green "$($identities.Count) objects in scope."
	
$arrResults = @()

ForEach ($User in [Array] $identities)
{
		$VIP = Get-ADUser -Identity $User.Email -Properties directreports, DisplayName, Title
        $Got = $VIP | Select-Object -ExpandProperty DirectReports
        ForEach ($Report in [Array] $Got)
{       $OutUser = Get-Aduser -Identity $Report -Properties DisplayName, Title, Office, Mail | Where {$_.Title -like "*Executive Assistant*"}
        

	
 #Process for output

    $objEX = New-Object -TypeName PSObject
        
    $objEX | Add-Member -MemberType NoteProperty -Name VIPNAME -Value $VIP.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name VIPTITLE -Value $VIP.Title

    $objEX | Add-Member -MemberType NoteProperty -Name ReportName -Value $OutUser.Name

    $objEX | Add-Member -MemberType NoteProperty -Name ReportDisplay -Value $OutUser.DisplayName
    
    $objEX | Add-Member -MemberType NoteProperty -Name ReportMail -Value $OutUser.Mail

    $objEX | Add-Member -MemberType NoteProperty -Name ReportTitle -Value $OutUser.Title
    
    $objEX | Add-Member -MemberType NoteProperty -Name ReportOffice -Value $OutUser.Office

    $arrResults += $objEX 

#>
}
}

$arrResults | Out-GridView

<#
#-----------------------------------------------------------------------------
# END OF SCRIPT: [Create Batches from Full Access Groups]
#-----------------------------------------------------------------------------
#>