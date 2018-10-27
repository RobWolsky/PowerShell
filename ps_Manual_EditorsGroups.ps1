# FileName:  ps_FindSharedandEditorsGroups.ps1
#----------------------------------------------------------------------------
# Script Name: [Find "Editors" group and members for each Shared Mailbox at IFF]
# Created: [06/26/2018]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@ntekcloud.com
# Requirements: 
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Prepare a list of users to communicate client side changes in profile
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: 
# Time: 
# Issue: New Script. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------


#Populate Identity Array
#[Array] $identities = Get-EXLMailbox -ResultSize unlimited | ? {($_.CustomAttribute15 | Out-String).Contains("Shared")}  | Select Name, DisplayName, SAMAccountName, IsShared
[Array] $identities = Get-Content C:\Temp\groupcheck.txt 

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($item in [Array] $identities)
{
$editors = ""
$shared = Get-ExlMailbox -Identity $item  | Select Name, DisplayName, SAMAccountName, IsShared
#Process mailbox for FullAccess Permissions
trap { 'Shared Mailbox: '+$shared.DisplayName+' has no Editors Group'; continue }
$editors = Get-EXLMailboxPermission -Identity $shared.Name -ErrorAction Stop | ? {($_.IsInherited -eq $false) -and ($_.User -notlike “NT AUTHORITY\SELF”) -and ($_.User -notlike "S-1-5*")} | Select User,AccessRights

    ForEach ($group in [Array] $editors)
    {

        $got = Get-ADGroup -Identity (($group.User | Out-String).Split('\')[1]).Trim()
        
        $members = $got | get-adgroupmember 
        ForEach ($member in [Array] $members)
        {
        
        $objEX = New-Object -TypeName PSObject

        $objEX | Add-Member -MemberType NoteProperty -Name SharedMailbox -Value $shared.DisplayName

        $objEX | Add-Member -MemberType NoteProperty -Name SharedAlias -Value $shared.Name

        $objEX | Add-Member -MemberType NoteProperty -Name EditorsGroup -Value $group.User

        $objEX | Add-Member -MemberType NoteProperty -Name AccessRights -Value $group.AccessRights
    
        $objEX | Add-Member -MemberType NoteProperty -Name User -Value $member.Name

        $arrResults += $objEX 
        }
    }
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\ADUSERWITHMANAGER_RESULT.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Find Mailboxes with Send-As permissions]
#-----------------------------------------------------------------------------
#>