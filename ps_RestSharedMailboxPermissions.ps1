# FileName:  ps_ResetSharedMailboxPermissions.ps1
#----------------------------------------------------------------------------
# Script : [Reset EDITORS group delegate permissions on Shared Mailboxes]
# Created: [09/13/2018]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: CSV file containing shared mailbox name, alias, editors group name, and mailbox smtp address
# Requirements: List relevant identities in c:\Temp\upn_batch.csv (header Name)
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: First pass of batch generation - Groups with Full Access permissions
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [09/13/2018]
# Time: [08:18]
# Issue: Created for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section  
#-----------------------------------------------------------------------------

$identities = @()
#Populate Identity Array
[Array] $identities = Import-Csv C:\temp\shared.csv

#Initialize array variable used to store records for output

Write-Host -ForegroundColor Green "Processing Shared Mailbox objects."
Write-Host -ForegroundColor Green "$($identities.Count) objects in scope."
	
ForEach ($User in [Array] $identities)
{
Add-EXORecipientPermission -Identity $User.SharedMailboxAlias -Trustee $User.EditorGroupName -AccessRights SendAs -Confirm:$false
Set-EXOMailbox -identity $User.SMTP -MessageCopyForSentAsEnabled $true
#>
}






<#
#-----------------------------------------------------------------------------
# END OF SCRIPT: [Reset EDITORS group delegate permissions on Shared Mailboxes]
#-----------------------------------------------------------------------------
#>