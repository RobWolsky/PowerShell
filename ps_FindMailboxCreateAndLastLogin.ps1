# FileName:  ps_FindMailboxCreateAndLastLogin.ps1
#----------------------------------------------------------------------------
# Script : [Find all mailboxes, when created, last loging and last login username]
# Created: [03/20/2018]
# Author: Rob Wolsky
# Company: NovaTech Group
# Email: rob.wolsky@novatechgroup.onmicrosoft.com
# Requirements: 
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Discovery for Modern Authentication rollout prep
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


#Populate Mailbox Array
[Array] $mailboxes = get-exlmailbox -ResultSize Unlimited

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($mailuser in [Array] $mailboxes)
{
#Process mailbox for statistics
$statistics = ""
$folders = ""
#trap { 'User: '+$mailuser.DisplayName+' has an issue'; continue }
$statistics = Get-exlmailboxstatistics -Identity $mailuser.SamAccountName | Select DisplayName, LastLoggedOnUserAccount, LastLogonTime, LastLogoffTime, ItemCount, TotalItemSize
$folders = Get-EXLMailboxFolderStatistics -Identity $mailuser.SamAccountName | Where {$_.Name -match “Inbox|Sent Items|Deleted Items”} | Select Name, ItemsInFolder
    $objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Display -Value $mailuser.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name Name -Value $mailuser.SamAccountName

    $objEX | Add-Member -MemberType NoteProperty -Name CreateDate -Value $mailuser.WhenCreated

    $objEX | Add-Member -MemberType NoteProperty -Name ItemCount -Value $statistics.ItemCount
    
    $objEX | Add-Member -MemberType NoteProperty -Name Size -Value $statistics.TotalItemSize
    
    $objEX | Add-Member -MemberType NoteProperty -Name DeletedItems -Value $folders[0].ItemsInFolder
    
    $objEX | Add-Member -MemberType NoteProperty -Name InboxItems -Value $folders[1].ItemsInFolder
    
    $objEX | Add-Member -MemberType NoteProperty -Name SentItems -Value $folders[2].ItemsInFolder
    
    $objEX | Add-Member -MemberType NoteProperty -Name LastLoggedIn -Value $statistics.LastLogonTime
    
    $objEX | Add-Member -MemberType NoteProperty -Name LastLoggedUser -Value $statistics.LastLoggedOnUserAccount
    
    $objEX | Add-Member -MemberType NoteProperty -Name LastLogoffTime -Value $statistics.LastLogoffTime

    $arrResults += $objEX 
    
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\mailuserWITHMANAGER_RESULT.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Find Mailboxes with Send-As permissions]
#-----------------------------------------------------------------------------
#>