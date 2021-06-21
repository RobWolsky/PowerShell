
$groups = Get-PowerBIWorkspace -Scope Organization -All
$arrResults = @()

ForEach ($group in [Array] $groups)
{
$users = $group.Users
ForEach ($user in [Array] $users)
{

    $objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Workspace -Value $group.Name

    $objEX | Add-Member -MemberType NoteProperty -Name Description -Value $group.Description

    $objEX | Add-Member -MemberType NoteProperty -Name Type -Value $group.Type

    $objEX | Add-Member -MemberType NoteProperty -Name State -Value $group.State

    $objEX | Add-Member -MemberType NoteProperty -Name OnDedicatedCapacity -Value $group.IsOnDedicatedCapacity

    $objEX | Add-Member -MemberType NoteProperty -Name AccessRight -Value  $user.AccessRight

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value  $user.UserPrincipalName
    
    $arrResults += $objEX 

}
#$group        
    }

$arrResults | Export-Csv -Path 'C:\Temp\Workspaces.csv' -NoTypeInformation