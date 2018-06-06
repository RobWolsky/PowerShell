
$identities = @()
#Populate Identity Array
[Array] $identities = Import-Csv C:\temp\batch_users.csv
$Cred = Get-Credential

ForEach ($User in [Array] $identities)
{
$a = Get-ADUser $User.Name 

    Add-ADGroupMember Global_Manufacturing_Users $a.Name -Credential $Cred
    Write-Host $a.Name
}


