

#Populate Identity Array
[Array] $identities = get-content C:\temp\transcript.txt



ForEach ($a in [Array] $identities)
{
    $aduser = Get-Aduser -Filter 'UserPrincipalName -eq $a'
    Grant-CsClientPolicy -Identity $aduser.UserPrincipalName -PolicyName $Null
}

<#
Set-PSSessionConfiguration
   [-Name] <String>
   [-AssemblyName] <String>
   [-ApplicationBase <String>]
   [-ConfigurationTypeName] <String>
   [-RunAsCredential <PSCredential>]
   [-ThreadApartmentState <ApartmentState>]
   [-ThreadOptions <PSThreadOptions>]
   [-AccessMode <PSSessionConfigurationAccessMode>]
   [-UseSharedProcess]
   [-StartupScript <String>]
   [-MaximumReceivedDataSizePerCommandMB <Double>]
   [-MaximumReceivedObjectSizeMB <Double>]
   [-SecurityDescriptorSddl <String>]
   [-ShowSecurityDescriptorUI]
   [-Force]
   [-NoServiceRestart]
   [-PSVersion <Version>]
   [-SessionTypeOption <PSSessionTypeOption>]
   [-TransportOption <PSTransportOption>]
   [-ModulesToImport <Object[]>]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]

   #>