# FileName:  ps_BatchGroups.ps1
#----------------------------------------------------------------------------
# Script Name: [Create Batches from Full Access Groups]
# Created: [07/27/2017]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: CSV file containing mailboxes to search by CN or UPN
# Requirements: List relevant identities in c:\Temp\sendas.csv (header Name)
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: First pass of batch generation - Groups with Full Access permissions
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [08/08/2017]
# Time: [15:52]
# Issue: Update for IFF. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

$identities = @()
#Populate Identity Array
[Array] $identities = Import-Csv C:\temp\fullaccess_results.csv

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($mailbox in [Array] $identities)
{
if (($mailbox.User | Out-String).Contains("GLOBAL\")) {

    $group = ($mailbox.User -split "\\",2)[1]
    Write-Host $group
#Process group name for AD member data, recursively drill down into nested groups to capture users
#$found = Get-ADGroup -Identity $mailbox.User.TrimStart("GLOBAL\")
#trap { 'Alias: '+$mailbox.User+' not found - NOT A GROUP'; continue }
Try {
    $found = Get-ADGroup -Identity $group
    #$found = Get-ADGroup -Identity $mailbox.User.TrimStart("GLOBAL\")
} Catch {
  Write-Host 'Alias: ' $mailbox.User 'not found - NOT A GROUP' -fore white -back red
}




#Find group members

Get-ADGroupMember $found -Recursive | Select Name | % {


    $objEX = New-Object -TypeName PSObject

    #Process mailbox for output

    
    $objEX | Add-Member -MemberType NoteProperty -Name Mailbox -Value $mailbox.Mailbox

    $objEX | Add-Member -MemberType NoteProperty -Name Alias -Value $mailbox.Alias

    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $mailbox.User

    $objEX | Add-Member -MemberType NoteProperty -Name Access -Value $mailbox.Access

    $objEX | Add-Member -MemberType NoteProperty -Name Member -Value $_.Name
    
    $arrResults += $objEX 
    }
     
  }
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\BatchGroups.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Create Batches from Full Access Groups]
#-----------------------------------------------------------------------------
#>