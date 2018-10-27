ForEach ($User in $Users)
{
    $loc = get-aduser -Identity $User -Properties UserPrincipalName, iffCountryCode #| Select Name, iffCountryCode | Out-GridView
    
    if (Get-MsolUser -UserPrincipalName $loc.UserPrincipalName | ? {(($_.Licenses | Out-String) -notlike "*PACK*") -and (($_.BlockCredential -ne $true))})
    {

    Set-MsolUser -UserPrincipalName $loc.UserPrincipalName -UsageLocation $loc.iffCountryCode
    Set-MsolUserLicense -UserPrincipalName $loc.UserPrincipalName -AddLicenses "IFF:STANDARDPACK"
    
    #Verify
    #Get-MsolUser -UserPrincipalName $User.UserPrincipalName | Select UserPrincipalName, Licenses, UsageLocation
    
    #Cleanup
    $loc = $null
    }
    Else 
    {
    Write-Host ("User "+$loc.UserPrincipalName+" is already licensed")
    }
}
#>