# FileName:  ps_GetAllMSOLLicenses.ps1
#----------------------------------------------------------------------------
# Script Name: [Get all users, iterate, output all assigned licenses in MSOL]
# Created: [04/18/2018]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: 
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Find all assigned licenses in client tenant
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [04/18/2018]
# Time: [08:52]
# Issue: Update for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

$identities = @()
#Populate Identity Array
[Array] $identities = Get-ADUser -Filter * -Properties DisplayName,DistinguishedName #-ResultSetSize 1000 

#Initialize array variable used to store records for output

Write-Host -ForegroundColor Green "Processing user objects."
Write-Host -ForegroundColor Green "$($identities.Count) objects in scope."
	
$arrResults = @()

ForEach ($User in [Array] $identities)
{
    try {
    $verify = Get-MSOLUser -UserPrincipalName $User.UserPrincipalName -ErrorAction Stop
    } catch [Microsoft.Online.Administration.Automation.MicrosoftOnlineException]{
    #Process for output

    $objEX = New-Object -TypeName PSObject
        
    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $User.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name ID -Value $User.Name

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $User.UserPrincipalName

    $objEX | Add-Member -MemberType NoteProperty -Name DN -Value $User.DistinguishedName

    $objEX | Add-Member -MemberType NoteProperty -Name License -Value "NOT SYNCHED TO MSOL"

    
    $arrResults += $objEX 
    ; continue}
    if ($verify.isLicensed -eq $false) {
    #Write-Host -BackgroundColor Red "User $($User.UserPrincipalName) not licensed"
    #Process for output

    $objEX = New-Object -TypeName PSObject
        
    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $User.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name ID -Value $User.Name

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $User.UserPrincipalName

    $objEX | Add-Member -MemberType NoteProperty -Name DN -Value $User.DistinguishedName

    $objEX | Add-Member -MemberType NoteProperty -Name License -Value "UNLICENSED"

    
    $arrResults += $objEX 
    ; continue}
    
    $Got = $verify | Select-Object -ExpandProperty Licenses
        ForEach ($License in [Array] $Got)
{       $OutSKU = $License.AccountSKUID
        

	
 #Process for output

    $objEX = New-Object -TypeName PSObject
        
    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $User.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name ID -Value $User.Name

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $User.UserPrincipalName
    
    $objEX | Add-Member -MemberType NoteProperty -Name DN -Value $User.DistinguishedName

    $objEX | Add-Member -MemberType NoteProperty -Name License -Value $OutSku

    
    $arrResults += $objEX 

#>
}
}

$arrResults | Out-GridView

<#
#-----------------------------------------------------------------------------
# END OF SCRIPT: [Find all assigned licenses in client tenant]
#-----------------------------------------------------------------------------
#>
