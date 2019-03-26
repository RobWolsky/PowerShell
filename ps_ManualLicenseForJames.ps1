$Users = get-content C:\temp\license.txt

ForEach ($User in $Users)
{
    #$loc = get-aduser -Identity $User -Properties UserPrincipalName, iffCountryCode #| Select Name, iffCountryCode | Out-GridView
    $a = get-aduser -Identity $User -Properties UserPrincipalName | Select UserPrincipalName
    if (Get-MsolUser -UserPrincipalName $a.UserPrincipalName | ? {(($_.Licenses | Out-String) -notlike "*MCOMEETADV*") -and (($_.BlockCredential -ne $true))})
    {

    Set-MsolUserLicense -UserPrincipalName $a.UserPrincipalName -AddLicenses "IFF:MCOMEETADV"
    
    #Write-Host ("User "+$a.UserPrincipalName+" is NOT licensed")
    }
    Else 
    {
    Write-Host ("User "+$a.UserPrincipalName+" is already licensed")
    }
#>
}
