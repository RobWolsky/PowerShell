
$dls = @()
#Populate Identity Array
[Array] $dls = get-content C:\temp\mattdls\dynamic.txt

#Initialize array variable used to store records for output

#$arrResults = @()

ForEach ($dl in [Array] $dls)
{
$out = @()
$out = Get-Recipient -ResultSize Unlimited -RecipientPreviewFilter (Get-DynamicDistributionGroup $dl.Trim()).RecipientFilter
#Out-File -InputObject $out -FilePath "C:\Temp\MattDLs\$dl.txt"
$out | Select DisplayName, PrimarySMTPAddress | Export-Csv -Path "C:\temp\MattDLs\$dl.csv"
}

$names = @()
#Populate Identity Array
[Array] $names = import-csv "C:\Temp\MattDLs\EC3Inputs.csv"  

ForEach ($name in [Array] $names)
{
$list = $name.CondensedName
$mgr = $name.Name
#Set-DynamicDistributionGroup -Identity ("dyn_EC3_"+$list) -RecipientFilter "(RecipientTypeDetails -eq 'UserMailbox') -and (CustomAttribute6 -eq '$mgr')"
Set-DynamicDistributionGroup -Identity ("dyn_EC3_"+$list) -ModerationEnabled:$false
}

$names = @()
#Populate Identity Array
[Array] $names = import-csv "C:\Temp\MattDLs\EC2Inputs.csv"  

ForEach ($name in [Array] $names)
{
$list = $name.CondensedName
$mgr = $name.Name
#Set-DynamicDistributionGroup -Identity ("dyn_EC2_"+$list) -RecipientFilter "(RecipientTypeDetails -eq 'UserMailbox') -and (CustomAttribute5 -eq '$mgr')"
Set-DynamicDistributionGroup -Identity ("dyn_EC2_"+$list) -ModerationEnabled:$false
}

<#
#Find group members

Get-ADGroupMember $found -Recursive | Select Name | % {

#Process mailbox for output

    $objEX = New-Object -TypeName PSObject

    $objEX | Add-Member -MemberType NoteProperty -Name Mailbox -Value $mailbox.Mailbox

    $objEX | Add-Member -MemberType NoteProperty -Name Group -Value $mailbox.User

    $objEX | Add-Member -MemberType NoteProperty -Name Member -Value $_.Name

    $objEX | Add-Member -MemberType NoteProperty -Name ExtendedRights -Value $Mailbox.ExtendedRights
        
    $arrResults += $objEX 
    }
     
  }
}

$arrResults | Out-GridView
#$arrResults | Export-Csv -Path 'C:\Temp\BatchGroups.csv' -NoTypeInformation 

#-----------------------------------------------------------------------------
# END OF SCRIPT: [Create Batches from SendAs Groups]
#-----------------------------------------------------------------------------
#>#>