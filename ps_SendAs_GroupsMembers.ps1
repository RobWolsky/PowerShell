# FileName:  ps_SendAsExtractGroups.ps1
#----------------------------------------------------------------------------
# Script Name: [Extract Group Memebers from SendAs Results]
# Created: [07/27/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@novatechgroup.onmicrosoft.com
# Requirements: CSV file containing mailboxes to search by CN or UPN
# Requirements: List relevant identities in c:\Temp\sendas.csv (header Name)
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: First pass of batch generation - Groups with SendAs permissions
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [08/09/2017]
# Time: [11:42]
# Issue: Update for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

$identities = @()
#Populate Identity Array
[Array] $identities = Import-Csv C:\temp\sendas_results.csv

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($mailbox in [Array] $identities)
{
if (($mailbox.User | Out-String).Contains("GLOBAL\")) {

    $group = ($mailbox.User -split "\\",2)[1]
    Write-Host $group

#Process group name for AD member data, recursively drill down into nested groups to capture users

Try {
    $found = Get-ADGroup -Identity $group
} Catch {
  Write-Host 'Alias: ' $mailbox.User 'not found - NOT A GROUP' -fore white -back red
  continue
}




#Find group members

Get-ADGroupMember $found -Recursive | Select Name | % {

#Process mailbox for output

    $objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Mailbox -Value $mailbox.Mailbox

    $objEX | Add-Member -MemberType NoteProperty -Name Group -Value $mailbox.User

    $objEX | Add-Member -MemberType NoteProperty -Name Member -Value $_.Name

    $objEX | Add-Member -MemberType NoteProperty -Name ExtendedRights -Value $Mailbox.ExtendedRights
        
    $arrResults += $objEX 
    }
     
  }
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\BatchGroups.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Create Batches from SendAs Groups]
#-----------------------------------------------------------------------------
#>