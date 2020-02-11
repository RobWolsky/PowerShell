# FileName:  ps_FindFullAccess.ps1
#----------------------------------------------------------------------------
# Script Name: [Find Mailboxes FullAccess ADPermissions]
# Created: [07/31/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: 
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Investigation of MailboxPermissions for Office 365 migration project
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [07/31/2017]
# Time: [1148]
# Issue: Update for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------


#Populate Identity Array
[Array] $identities = Get-Mailbox "rxw1401"
#[Array] $identities = Get-Mailbox -ResultSize unlimited

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($mailbox in [Array] $identities)
{

#Process mailbox for FullAccess Permissions
Get-MailboxPermission $mailbox | ? {($_.IsInherited | Out-String).Contains("False")} | % {

    $objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Display -Value $mailbox.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name Name -Value $mailbox.Name

    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $_.User

    $objEX | Add-Member -MemberType NoteProperty -Name AccessRight -Value $_.AccessRights

    $arrResults += $objEX 
    } 
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\FULLACCESS_RESULT.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Find Mailboxes with Send-As permissions]
#-----------------------------------------------------------------------------
#>