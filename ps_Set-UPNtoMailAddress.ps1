# FileName:  ps_Set-UPNtoMailAddress.ps1
#----------------------------------------------------------------------------
# Script Name: [Set User UPN to Match Mail attribute for a batch of users]
# Created: [12/18/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: CSV file containing mailboxes users to change UPN to Mail
# Requirements: List relevant identities in c:\Temp\upn_batch.csv (header Name)
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: First pass of batch generation - Groups with Full Access permissions
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [12/18/2017]
# Time: [14:13]
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
		$Got = Get-ADUser -Identity $User.Email -Properties DistinguishedName, userPrincipalName,mail,msExchRecipientTypeDetails #| ? { $_.msExchRecipientTypeDetails -eq "1" }
	    $objBefore = Get-ADObject -Identity $Got.DistinguishedName -Properties UserPrincipalName,Mail
		If ($objBefore.Mail)
			{
			Set-ADObject -Identity $Got.DistinguishedName -Replace @{userPrincipalName=$($Got.mail)}
			$objAfter = Get-ADObject -Identity $Got.DistinguishedName -Properties UserPrincipalName,Mail
			If ($LogFile)
				{
				$LogData = """" + $objBefore.DistinguishedName + """" + "," + """" + $objBefore.UserPrincipalName + """" + "," + """" + $objBefore.Mail + """" + "," + """" + $objAfter.UserPrincipalName + """" + "," + """" + $objAfter.Mail + """"
				$LogData | Out-File $LogFile -Append
				}
			}
		Else 
			{ 
			Write-Host -NoNewline "User ";Write-Host -NoNewLine -ForegroundColor Red "$($objBefore.UserPrincipalName) "; Write-Host "does not have a valid mail attribute."
			$data = """" + $objBefore.UserPrincipalName + """" + "," + """" + "Missing or corrupt mail attribute." + """"
			$data | Out-File Errorlog.txt -Append
			}
		
  <#Process mailbox for output

    $objEX = New-Object -TypeName PSObject
        
    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $User.UPN

    $objEX | Add-Member -MemberType NoteProperty -Name Mail -Value $objAfter.Mail

    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $objAfter.Name

    $arrResults += $objEX 

    $objBefore = $null
    $objAfter = $null
	$LogData = $null
#>
}





#$arrResults | Out-GridView

<#
#-----------------------------------------------------------------------------
# END OF SCRIPT: [Create Batches from Full Access Groups]
#-----------------------------------------------------------------------------
#>