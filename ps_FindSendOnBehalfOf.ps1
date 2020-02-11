# FileName:  ps_FindSendAs.ps1
#----------------------------------------------------------------------------
# Script Name: [Find Mailboxes with Send-On-Behalf permissions]
# Created: [07/31/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: 
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Investigation of Send-On-Behalf permissions for Office 365 migration project
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [07/31/2017]
# Time: [0944]
# Issue: Update for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------


#Populate Identity Array
[Array] $identities = Get-Mailbox -ResultSize unlimited

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($mailbox in [Array] $identities)
{

#Process mailbox for Send-On-Behalf
Get-Mailbox -Identity $mailbox | ? {$_.GrantSendOnBehalfTo} | % {
    
    $entries = $mailbox.GrantSendOnBehalfTo

    ForEach ($entry in $entries) 
    {
    
    $objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Display -Value $mailbox.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name Name -Value $_.Name

    $objEX | Add-Member -MemberType NoteProperty -Name Grant -Value $entry

    $arrResults += $objEX 
    }
    } 
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\SENDONBEHALF_RESULT.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Find Mailboxes with Send-As permissions]
#-----------------------------------------------------------------------------
#>