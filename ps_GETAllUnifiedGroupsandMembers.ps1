$Groups = Get-UnifiedGroup -ResultSize Unlimited
$Groups | ForEach-Object {
$group = $_
Get-UnifiedGroupLinks -Identity $group.Name -LinkType Owners -ResultSize Unlimited | ForEach-Object {
      New-Object -TypeName PSObject -Property @{
       Group = $group.DisplayName
       Member = $_.Name
       EmailAddress = $_.PrimarySMTPAddress
       RecipientType= $_.RecipientType
}}} | Export-CSV "C:\Office365GroupMembers.csv" -NoTypeInformation -Encoding UTF8


$Groups = Get-PowerBIWorkspace -Scope Organization
$Groups | ForEach-Object {
    $group = $_
    Get-UnifiedGroupLinks -Identity $group.Name -LinkType Members -ResultSize Unlimited | ForEach-Object {
        $member = $_
        New-Object -TypeName PSObject -Property @{
            Member = $member.Name
            Group = $group.Name
        }
    }
} | Export-CSV "C:\TEMP\Workspaces.csv" -NoTypeInformation -Encoding UTF8