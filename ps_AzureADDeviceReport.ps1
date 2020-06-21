# FileName:  ps_AzureADDeviceReport.ps1
#----------------------------------------------------------------------------
# Script Name: [Retrieve All Azure AD Devices with Registered User Name]
# Created: [06/03/2020]
# Author: Rob Wolsky
# Company: IFF
# Email: rob.wolsky@iff.com
# Requirements: AzureAD PowerShell Module
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Inventory of registered users and devices in Azure AD
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [06/03/2020]
# Time: [10:56]
# Issue: First Revision. 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

$devices = @()
#Populate Identity Array
[Array] $devices = Get-AzureADDevice -All:$true
#[Array] $devices = Get-AzureADDevice -Top 5

#Initialize array variable used to store records for output

$arrResults = @()

ForEach ($device in [Array] $devices)
{
#Process device and find register user 

Try {
    $found = Get-AzureADDeviceRegisteredUser -ObjectId $device.ObjectId
} Catch {
  Write-Host 'Device: ' $device.DisplayName 'not found' -fore white -back red
  continue
}

    $objEX = New-Object -TypeName PSObject

    #Process device for output
    
    $objEX | Add-Member -MemberType NoteProperty -Name Device -Value $device.DisplayName
    $objEX | Add-Member -MemberType NoteProperty -Name Type -Value $device.ObjectType
    $objEX | Add-Member -MemberType NoteProperty -Name ObjectID -Value $device.ObjectID
    $objEX | Add-Member -MemberType NoteProperty -Name ProfileType -Value $device.ProfileType
    $objEX | Add-Member -MemberType NoteProperty -Name DeviceOS -Value $device.DeviceOSType
    
    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $found.DisplayName
    $objEX | Add-Member -MemberType NoteProperty -Name Mail -Value $found.Mail
    $objEX | Add-Member -MemberType NoteProperty -Name UserID -Value $found.MailNickName
    
    $arrResults += $objEX 
    
}

$arrResults | Out-GridView

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Retrieve All Azure AD Devices with Registered User Name]
#-----------------------------------------------------------------------------
#>