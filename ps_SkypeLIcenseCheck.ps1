ForEach ($User in $Users)
{
    $loc = get-aduser -Identity $User -Properties UserPrincipalName, iffCountryCode #| Select Name, iffCountryCode | Out-GridView
    
    Get-MsolUser -UserPrincipalName $loc.UserPrincipalName | Select Licenses, UserPrincipalName | ? {($_.Licenses | Out-String) -like "*ENTERPRISE*"}
}
#>