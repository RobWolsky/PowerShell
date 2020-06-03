$O365Group = (Get-UnifiedGroup -Identity "CodeTwo_Test")
$SecurityGroup = (Get-AzureADGroup -SearchString "GBWH_signature")
# Grab list of security group members
$SecurityGroupMembers = (Get-AzureADGroupMember -ObjectId $SecurityGroup.ObjectId | Select UserPrincipalName, Membertype)

ForEach ($i in $SecurityGroupMembers) {
    If ($i.UserType -eq "User") {
    Add-UnifiedGroupLinks -Identity $O365Group.Alias -LinkType Member -Links $i.UserPrincipalName }
    }

$GroupMembers = (Get-UnifiedGroupLinks -Identity $O365Group.Alias -LinkType Member)
ForEach ($i in $GroupMembers) {
    $Member = (Get-Mailbox -Identity $i.Name)
    If ($SecurityGroupMembers -Match $Member.UserPrincipalName)
    {Write-Host $Member.DisplayName "is in security group" }
Else
    { Write-Host "Removing" $Member.DisplayName "from Office 365 group because they are not in the security group" -ForeGroundColor Red
    Remove-UnifiedGroupLinks -Identity $O365Group.Alias -Links $Member.Alias -LinkType Member -Confirm:$False}
    }
Write-Host "Current Membership of" $O365Group.DisplayName
Get-UnifiedGroupLinks -Identity $O365Group.Alias -LinkType Member