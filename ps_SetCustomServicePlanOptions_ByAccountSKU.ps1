#License Commands
Get-MsolAccountSku
(Get-MsolAccountSku | where {$_.AccountSkuId -eq 'IFF:STANDARDPACK'}).ServiceStatus
(Get-MsolAccountSku | where {$_.AccountSkuId -eq 'IFF:ENTERPRISEPACK'}).ServiceStatus
Get-MsolUser -UserPrincipalName rob.wolsky@iff.com | Format-List DisplayName,Licenses

(Get-MsolUser -UserPrincipalName rob.wolsky@iff.com).Licenses[2].ServiceStatus

Get-MsolUser -All | where {$_.isLicensed -eq $true -and $_.Licenses[<LicenseIndexNumber> ].ServiceStatus[<ServiceIndexNumber> ].ProvisioningStatus <-eq | -ne> "Disabled" -and $_.Licenses[<LicenseIndexNumber> ].ServiceStatus[<ServiceIndexNumber> ].ProvisioningStatus <-eq | -ne> "Disabled"...}

#Example Set New Options for all E3 Users
$LO = New-MsolLicenseOptions -AccountSkuId "IFF:ENTERPRISEPACK" -DisabledPlans "Deskless", "FLOW_O365_P2", "POWERAPPS_O365_P2", "RMS_S_ENTERPRISE"
$acctSKU="IFF:ENTERPRISEPACK"
$AllLicensed = Get-MsolUser -MaxResults 100 | ? {($_.Licenses | Out-String) -like "*ENTERPRISEPACK*"} | Select UserPrincipalName, DisplayName, Licenses | Out-GridView
$AllLicensed | ForEach {Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -LicenseOptions $LO}


#Role Management
Get-MsolRole | Sort Name | Select Name,Description
