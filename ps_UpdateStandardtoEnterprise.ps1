# Create a list of users to swap licenses in C:\Temp named Users.txt

$Users = @()
#Populate Identity Array
[Array] $Users = Get-Content C:\temp\Users.txt

#check that the user is licensed, then swap E3 for E1
ForEach ($User in $Users)
{
    if (Get-MsolUser -UserPrincipalName $User | ? {(($_.Licenses | Out-String) -notlike "*PACK*") -and (($_.BlockCredential -ne $true))})
    {

    Write-Host ("User "+$User+" is not currently licensed"); continue

    }
    Else
    {
    Set-MsolUserLicense -UserPrincipalName $User -AddLicenses "IFF:ENTERPRISEPACK" -RemoveLicenses "IFF:STANDARDPACK"
    }
}
#>