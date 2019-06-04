# .SYNOPSIS
#   Helps admin to update the AzureADPolicy for Allow/Block domain list for inviting external Users.
#   Powershell must be connected to Azure AD Preview V2 before running this script.
#
#   Copyright (c) Microsoft Corporation. All rights reserved.
#
#   THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK
#   OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#
# .PARAMETER Update
#    Parameter to update allow or block domain list.
#
# .PARAMETER Append
#    Parameter to append domains to an existing allow or block domain list.
#
# .PARAMETER AllowList
#    Parameter to specify list of allowed domains.
#
# .PARAMETER BlockList
#    Parameter to specify list of blocked domains.
#
# .PARAMETER MigrateFromSharepoint
#    Switch parameter to migrate AllowBlockDomainList from SPO.
#
# .PARAMETER Remove
#    Switch parameter to delete the existing policy.
#
# .PARAMETER QueryPolicy
#    Switch parameter to query the existing policy.
#
# .Example
#	Set-GuestAllowBlockDomainPolicy.ps1 -Update -AllowList @("contoso.com", "fabrikam.com")
#
# .Example
#	Set-GuestAllowBlockDomainPolicy.ps1 -Append -AllowList @("contoso.com")
#
# .Example
#	Set-GuestAllowBlockDomainPolicy.ps1 -Update -BlockList @("fabrikam.com", "contoso.com")
#
# .Example
#	Set-GuestAllowBlockDomainPolicy.ps1 -Append -BlockList @("fabrikam.com")
#
# .Example
#	Set-GuestAllowBlockDomainPolicy.ps1 -MigrateFromSharepoint
#
# .Example
#	Set-GuestAllowBlockDomainPolicy.ps1 -Remove
#
# .Example
#	Set-GuestAllowBlockDomainPolicy.ps1 -QueryPolicy
#
Param(
        [Parameter(Mandatory=$true, ParameterSetName="Update+BlockList")]
        [Parameter(Mandatory=$true, ParameterSetName="Update+AllowList")]
        [Switch] $Update,
        [Parameter(Mandatory=$true, ParameterSetName="Append+BlockList")]
        [Parameter(Mandatory=$true, ParameterSetName="Append+AllowList")]
        [Switch] $Append,
        [Parameter(Mandatory=$true, ParameterSetName="Append+BlockList")]
        [Parameter(Mandatory=$true, ParameterSetName="Update+BlockList")]
        [String[]] $BlockList,
        [Parameter(Mandatory=$true, ParameterSetName="Append+AllowList")]
        [Parameter(Mandatory=$true, ParameterSetName="Update+AllowList")]
        [String[]] $AllowList,
        [Parameter(Mandatory=$true, ParameterSetName="MigrateFromSPOSet")]
        [switch] $MigrateFromSharepoint,
        [Parameter(Mandatory=$true, ParameterSetName="ClearPolicySet")]
        [switch] $Remove,
        [Parameter(Mandatory=$true, ParameterSetName="ExistingPolicySet")]
        [switch] $QueryPolicy
)

# Gets Json for the policy with given Allowed and Blocked Domain List
function GetJSONForAllowBlockDomainPolicy([string[]] $AllowDomains = @(), [string[]] $BlockedDomains = @())
{
    # Remove any duplicate domains from Allowed or Blocked domains specified.
    $AllowDomains = $AllowDomains | select -uniq
    $BlockedDomains = $BlockedDomains | select -uniq

    return @{B2BManagementPolicy=@{InvitationsAllowedAndBlockedDomainsPolicy=@{AllowedDomains=@($AllowDomains); BlockedDomains=@($BlockedDomains)}}} | ConvertTo-Json -Depth 3 -Compress
}

# Converts Json to Object since ConvertFrom-Json does not support the depth parameter.
function GetObjectFromJson([string] $JsonString)
{
    ConvertFrom-Json -InputObject $JsonString |
        ForEach-Object {
            foreach ($property in ($_ | Get-Member -MemberType NoteProperty)) 
                {
                    $_.$($property.Name) | Add-Member -MemberType NoteProperty -Name 'Name' -Value $property.Name -PassThru
                }
        }
}

# Gets AllowBlockedList from SPO
function GetSPOPolicy
{
    try
    {
        $SPOTenantSettings = Get-SPOTenant
    }
    catch [System.InvalidOperationException]
    {
        Write-Error "You must call Connect-SPOService cmdlet before using this parameter."
        Exit;
    }

    # Return JSON for Allow\Block domain list in SPO
    switch($SPOTenantSettings.SharingDomainRestrictionMode)
    {
        "AllowList"
        {
            Write-Host "`nSPO Allowed DomainList:" $SPOTenantSettings.SharingAllowedDomainList
            $AllowDomainsList = $SPOTenantSettings.SharingAllowedDomainList.Split(' ')
            return  GetJSONForAllowBlockDomainPolicy -AllowDomains $AllowDomainsList
            break;
        }
        "BlockList"
        {
            Write-Host "`nSPO Blocked DomainList:" $SPOTenantSettings.SharingBlockedDomainList
            $BlockDomainsList = $SPOTenantSettings.SharingBlockedDomainList.Split(' ')
            return GetJSONForAllowBlockDomainPolicy -BlockedDomains $BlockDomainsList
            break;
        }
        "None"
        {
            Write-Error "There is no AllowBlockDomainList policy set for this SPO tenant."
            return $null
        }
    }
}

# Gets the existing AzureAD policy for AllowBlockedList if it exists
function GetExistingPolicy
{
    $currentpolicy = Get-AzureADPolicy | ?{$_.Type -eq 'B2BManagementPolicy'} | select -First 1

    return $currentpolicy;
}

# Print Allowed and Blocked Domain List for the given policy
function PrintAllowBlockedList([String] $defString)
{
    $policyObj = GetObjectFromJson $defString;

    Write-Host "AllowedDomains: " $policyObj.InvitationsAllowedAndBlockedDomainsPolicy.AllowedDomains
    Write-Host "BlockedDomains: " $policyObj.InvitationsAllowedAndBlockedDomainsPolicy.BlockedDomains
}

# Gets AllowDomainList from the existing policy
function GetExistingAllowedDomainList()
{
    $policy = GetExistingPolicy

    if($policy -ne $null)
    {
        $policyObject = GetObjectFromJson $policy.Definition[0];

        if($policyObject.InvitationsAllowedAndBlockedDomainsPolicy -ne $null -and $policyObject.InvitationsAllowedAndBlockedDomainsPolicy.AllowedDomains -ne $null)
        {
            Write-Host "Existing Allowed Domain List: " $policyObject.InvitationsAllowedAndBlockedDomainsPolicy.AllowedDomains
            return $policyObject.InvitationsAllowedAndBlockedDomainsPolicy.AllowedDomains;
        }
    }

    return $null
}

# Gets BlockDomainList from the existing policy
function GetExistingBlockedDomainList()
{
    $policy = GetExistingPolicy

    if($policy -ne $null)
    {
        $policyObject = GetObjectFromJson $policy.Definition[0];

        if($policyObject.InvitationsAllowedAndBlockedDomainsPolicy -ne $null -and $policyObject.InvitationsAllowedAndBlockedDomainsPolicy.BlockedDomains -ne $null)
        {
            Write-Host "Existing Blocked Domain List: " $policyObject.InvitationsAllowedAndBlockedDomainsPolicy.BlockedDomains
            return $policyObject.InvitationsAllowedAndBlockedDomainsPolicy.BlockedDomains;
        }
    }

    return $null
}

# Main Script which sets the Allow/Block domain list policy according to the parameters specified by the user.
try
{
    $currentpolicy = GetExistingPolicy;
}
catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException]
{
    Write-Error "You must call Connect-AzureAD cmdlet before running this script."
    Exit
}

$policyExist = ($currentpolicy -ne $null)

switch ($PSCmdlet.ParameterSetName)
{
    "Update+BlockList"
    {
        Write-Host "Setting BlockDomainsList for B2BManagementPolicy";
        $policyValue = GetJSONForAllowBlockDomainPolicy -BlockedDomains $BlockList

        break;
    }
    "Update+AllowList"
    {
        Write-Host "Setting AllowedDomainList for B2BManagementPolicy";
        $policyValue = GetJSONForAllowBlockDomainPolicy -AllowDomains $AllowList

        break;
    }
    "Append+BlockList"
    {
        $ExistingBlockList = GetExistingBlockedDomainList

        if($ExistingBlockList -ne $null)
        {
            Write-Host "Appending Block Domain List to the current BlockDomainPolicy."
            $BlockList = $BlockList + $ExistingBlockList
        }
        else
        {
            Write-Host "Existing Block List is empty. Adding the domain list specified."
        }

        $policyValue = GetJSONForAllowBlockDomainPolicy -BlockedDomains $BlockList

        break;
    }
    "Append+AllowList"
    {
        $ExistingAllowList = GetExistingAllowedDomainList

        if($ExistingAllowList -ne $null)
        {
            Write-Host "Appending Allow Domain List to the current AllowDomainPolicy."
            $AllowList = $AllowList + $ExistingAllowList
            Write-Host $AllowList
        }
        else
        {
            Write-Host "Existing Allow List is empty. Adding the domain list specified."
        }

        $policyValue = GetJSONForAllowBlockDomainPolicy -AllowDomains $AllowList

        break;
    }
    "MigrateFromSPOSet"
    {
        $policyValue = GetSPOPolicy

        break;
    }
    "ClearPolicySet"
    {
        if($policyExist -eq $true)
        {
            Write-Host "Removing AzureAd Policy.";
            Remove-AzureADPolicy -Id $currentpolicy.Id | Out-Null
        }
        else
        {
            Write-Host "No policy to Remove."
        }

        Exit
    }
    "ExistingPolicySet"
    {
        if($currentpolicy -ne $null)
        {
            Write-Information "`nCurrent Allow/Block domain list policy:`n"
            PrintAllowBlockedList $currentpolicy.Definition[0];
        }
        else
        {
            Write-Host "No policy found for Allow/Block domain list in AzureAD."
        }

        Exit
    }
    "None"
    {
        Write-Error "`n`tPlease specify valid Parameters!`n`tExecute 'help GuestAllowBlockDomainPolicy.ps1 -examples' for examples."
        Exit
    }
}

if($policyExist -and $policyValue -ne $null)
{
    Write-Host "There is already an existing Policy for Allow/Block domain list."
    Write-Output "`nDetails for the Existing Policy in Azure AD: "
    PrintAllowBlockedList $currentpolicy.Definition[0];

    Write-Host "`nNew Policy Changes:"
    PrintAllowBlockedList $policyValue;

    $title = "Policy Change";
    $message = "Do you want to continue changing existing policy?";
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "Y"
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "N"

    [System.Management.Automation.Host.ChoiceDescription[]]$options = $no,$yes;
    $confirmation = $host.ui.PromptForChoice($title, $message, $options, 0);

    if ($confirmation -eq 0)
    {
        Exit
    }
    else
    {
        Write-Host "Executing User command."
    }

    Set-AzureADPolicy -Definition $policyValue -Id $currentpolicy.Id | Out-Null
}
else
{
    New-AzureADPolicy -Definition $policyValue -DisplayName B2BManagementPolicy -Type B2BManagementPolicy -IsOrganizationDefault $true -InformationAction Ignore | Out-Null
}

Write-Output "`nNew AzureAD Policy: "
$currentPolicy = GetExistingPolicy;
PrintAllowBlockedList $currentpolicy.Definition[0];

Exit

# SIG # Begin signature block
# MIIdyAYJKoZIhvcNAQcCoIIduTCCHbUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUM/+tY0F/qaZVtG8bN467Mw30
# 4G2gghhlMIIEwzCCA6ugAwIBAgITMwAAAMp9MhZ8fv0FAwAAAAAAyjANBgkqhkiG
# 9w0BAQUFADB3MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEw
# HwYDVQQDExhNaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EwHhcNMTYwOTA3MTc1ODU1
# WhcNMTgwOTA3MTc1ODU1WjCBszELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUGA1UECxMebkNpcGhlciBEU0UgRVNO
# OjcyOEQtQzQ1Ri1GOUVCMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj3CeDl2ll7S4
# 96ityzOt4bkPI1FucwjpTvklJZLOYljFyIGs/LLi6HyH+Czg8Xd/oDQYFzmJTWac
# A0flGdvk8Yj5OLMEH4yPFFgQsZA5Wfnz/Cg5WYR2gmsFRUFELCyCbO58DvzOQQt1
# k/tsTJ5Ns5DfgCb5e31m95yiI44v23FVpKnTY9CUJbIr8j28O3biAhrvrVxI57GZ
# nzkUM8GPQ03o0NGCY1UEpe7UjY22XL2Uq816r0jnKtErcNqIgglXIurJF9QFJrvw
# uvMbRjeTBTCt5o12D4b7a7oFmQEDgg+koAY5TX+ZcLVksdgPNwbidprgEfPykXiG
# ATSQlFCEXwIDAQABo4IBCTCCAQUwHQYDVR0OBBYEFGb30hxaE8ox6QInbJZnmt6n
# G7LKMB8GA1UdIwQYMBaAFCM0+NlSRnAK7UD7dvuzK7DDNbMPMFQGA1UdHwRNMEsw
# SaBHoEWGQ2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3Rz
# L01pY3Jvc29mdFRpbWVTdGFtcFBDQS5jcmwwWAYIKwYBBQUHAQEETDBKMEgGCCsG
# AQUFBzAChjxodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY3Jv
# c29mdFRpbWVTdGFtcFBDQS5jcnQwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZI
# hvcNAQEFBQADggEBAGyg/1zQebvX564G4LsdYjFr9ptnqO4KaD0lnYBECEjMqdBM
# 4t+rNhN38qGgERoc+ns5QEGrrtcIW30dvMvtGaeQww5sFcAonUCOs3OHR05QII6R
# XYbxtAMyniTUPwacJiiCSeA06tLg1bebsrIY569mRQHSOgqzaO52EzJlOtdLrGDk
# Ot1/eu8E2zN9/xetZm16wLJVCJMb3MKosVFjFZ7OlClFTPk6rGyN9jfbKKDsDtNr
# jfAiZGVhxrEqMiYkj4S4OyvJ2uhw/ap7dbotTCfZu1yO57SU8rE06K6j8zWB5L9u
# DmtgcqXg3ckGvdmWVWBrcWgnmqNMYgX50XSzffQwggYHMIID76ADAgECAgphFmg0
# AAAAAAAcMA0GCSqGSIb3DQEBBQUAMF8xEzARBgoJkiaJk/IsZAEZFgNjb20xGTAX
# BgoJkiaJk/IsZAEZFgltaWNyb3NvZnQxLTArBgNVBAMTJE1pY3Jvc29mdCBSb290
# IENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw0wNzA0MDMxMjUzMDlaFw0yMTA0MDMx
# MzAzMDlaMHcxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAf
# BgNVBAMTGE1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQTCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAJ+hbLHf20iSKnxrLhnhveLjxZlRI1Ctzt0YTiQP7tGn
# 0UytdDAgEesH1VSVFUmUG0KSrphcMCbaAGvoe73siQcP9w4EmPCJzB/LMySHnfL0
# Zxws/HvniB3q506jocEjU8qN+kXPCdBer9CwQgSi+aZsk2fXKNxGU7CG0OUoRi4n
# rIZPVVIM5AMs+2qQkDBuh/NZMJ36ftaXs+ghl3740hPzCLdTbVK0RZCfSABKR2YR
# JylmqJfk0waBSqL5hKcRRxQJgp+E7VV4/gGaHVAIhQAQMEbtt94jRrvELVSfrx54
# QTF3zJvfO4OToWECtR0Nsfz3m7IBziJLVP/5BcPCIAsCAwEAAaOCAaswggGnMA8G
# A1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFCM0+NlSRnAK7UD7dvuzK7DDNbMPMAsG
# A1UdDwQEAwIBhjAQBgkrBgEEAYI3FQEEAwIBADCBmAYDVR0jBIGQMIGNgBQOrIJg
# QFYnl+UlE/wq4QpTlVnkpKFjpGEwXzETMBEGCgmSJomT8ixkARkWA2NvbTEZMBcG
# CgmSJomT8ixkARkWCW1pY3Jvc29mdDEtMCsGA1UEAxMkTWljcm9zb2Z0IFJvb3Qg
# Q2VydGlmaWNhdGUgQXV0aG9yaXR5ghB5rRahSqClrUxzWPQHEy5lMFAGA1UdHwRJ
# MEcwRaBDoEGGP2h0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1
# Y3RzL21pY3Jvc29mdHJvb3RjZXJ0LmNybDBUBggrBgEFBQcBAQRIMEYwRAYIKwYB
# BQUHMAKGOGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljcm9z
# b2Z0Um9vdENlcnQuY3J0MBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0GCSqGSIb3DQEB
# BQUAA4ICAQAQl4rDXANENt3ptK132855UU0BsS50cVttDBOrzr57j7gu1BKijG1i
# uFcCy04gE1CZ3XpA4le7r1iaHOEdAYasu3jyi9DsOwHu4r6PCgXIjUji8FMV3U+r
# kuTnjWrVgMHmlPIGL4UD6ZEqJCJw+/b85HiZLg33B+JwvBhOnY5rCnKVuKE5nGct
# xVEO6mJcPxaYiyA/4gcaMvnMMUp2MT0rcgvI6nA9/4UKE9/CCmGO8Ne4F+tOi3/F
# NSteo7/rvH0LQnvUU3Ih7jDKu3hlXFsBFwoUDtLaFJj1PLlmWLMtL+f5hYbMUVbo
# nXCUbKw5TNT2eb+qGHpiKe+imyk0BncaYsk9Hm0fgvALxyy7z0Oz5fnsfbXjpKh0
# NbhOxXEjEiZ2CzxSjHFaRkMUvLOzsE1nyJ9C/4B5IYCeFTBm6EISXhrIniIh0EPp
# K+m79EjMLNTYMoBMJipIJF9a6lbvpt6Znco6b72BJ3QGEe52Ib+bgsEnVLaxaj2J
# oXZhtG6hE6a/qkfwEm/9ijJssv7fUciMI8lmvZ0dhxJkAj0tr1mPuOQh5bWwymO0
# eFQF1EEuUKyUsKV4q7OglnUa2ZKHE3UiLzKoCG6gW4wlv6DvhMoh1useT8ma7kng
# 9wFlb4kLfchpyOZu6qeXzjEp/w7FW1zYTRuh2Povnj8uVRZryROj/TCCBhEwggP5
# oAMCAQICEzMAAACOh5GkVxpfyj4AAAAAAI4wDQYJKoZIhvcNAQELBQAwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMTAeFw0xNjExMTcyMjA5MjFaFw0xODAy
# MTcyMjA5MjFaMIGDMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MQ0wCwYDVQQLEwRNT1BSMR4wHAYDVQQDExVNaWNyb3NvZnQgQ29ycG9yYXRpb24w
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDQh9RCK36d2cZ61KLD4xWS
# 0lOdlRfJUjb6VL+rEK/pyefMJlPDwnO/bdYA5QDc6WpnNDD2Fhe0AaWVfIu5pCzm
# izt59iMMeY/zUt9AARzCxgOd61nPc+nYcTmb8M4lWS3SyVsK737WMg5ddBIE7J4E
# U6ZrAmf4TVmLd+ArIeDvwKRFEs8DewPGOcPUItxVXHdC/5yy5VVnaLotdmp/ZlNH
# 1UcKzDjejXuXGX2C0Cb4pY7lofBeZBDk+esnxvLgCNAN8mfA2PIv+4naFfmuDz4A
# lwfRCz5w1HercnhBmAe4F8yisV/svfNQZ6PXlPDSi1WPU6aVk+ayZs/JN2jkY8fP
# AgMBAAGjggGAMIIBfDAfBgNVHSUEGDAWBgorBgEEAYI3TAgBBggrBgEFBQcDAzAd
# BgNVHQ4EFgQUq8jW7bIV0qqO8cztbDj3RUrQirswUgYDVR0RBEswSaRHMEUxDTAL
# BgNVBAsTBE1PUFIxNDAyBgNVBAUTKzIzMDAxMitiMDUwYzZlNy03NjQxLTQ0MWYt
# YmM0YS00MzQ4MWU0MTVkMDgwHwYDVR0jBBgwFoAUSG5k5VAF04KqFzc3IrVtqMp1
# ApUwVAYDVR0fBE0wSzBJoEegRYZDaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3Br
# aW9wcy9jcmwvTWljQ29kU2lnUENBMjAxMV8yMDExLTA3LTA4LmNybDBhBggrBgEF
# BQcBAQRVMFMwUQYIKwYBBQUHMAKGRWh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9w
# a2lvcHMvY2VydHMvTWljQ29kU2lnUENBMjAxMV8yMDExLTA3LTA4LmNydDAMBgNV
# HRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4ICAQBEiQKsaVPzxLa71IxgU+fKbKhJ
# aWa+pZpBmTrYndJXAlFq+r+bltumJn0JVujc7SV1eqVHUqgeSxZT8+4PmsMElSnB
# goSkVjH8oIqRlbW/Ws6pAR9kRqHmyvHXdHu/kghRXnwzAl5RO5vl2C5fAkwJnBpD
# 2nHt5Nnnotp0LBet5Qy1GPVUCdS+HHPNIHuk+sjb2Ns6rvqQxaO9lWWuRi1XKVjW
# kvBs2mPxjzOifjh2Xt3zNe2smjtigdBOGXxIfLALjzjMLbzVOWWplcED4pLJuavS
# Vwqq3FILLlYno+KYl1eOvKlZbiSSjoLiCXOC2TWDzJ9/0QSOiLjimoNYsNSa5jH6
# lEeOfabiTnnz2NNqMxZQcPFCu5gJ6f/MlVVbCL+SUqgIxPHo8f9A1/maNp39upCF
# 0lU+UK1GH+8lDLieOkgEY+94mKJdAw0C2Nwgq+ZWtd7vFmbD11WCHk+CeMmeVBoQ
# YLcXq0ATka6wGcGaM53uMnLNZcxPRpgtD1FgHnz7/tvoB3kH96EzOP4JmtuPe7Y6
# vYWGuMy8fQEwt3sdqV0bvcxNF/duRzPVQN9qyi5RuLW5z8ME0zvl4+kQjOunut6k
# LjNqKS8USuoewSI4NQWF78IEAA1rwdiWFEgVr35SsLhgxFK1SoK3hSoASSomgyda
# Qd691WZJvAuceHAJvDCCB3owggVioAMCAQICCmEOkNIAAAAAAAMwDQYJKoZIhvcN
# AQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAw
# BgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEx
# MB4XDTExMDcwODIwNTkwOVoXDTI2MDcwODIxMDkwOVowfjELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9zb2Z0IENvZGUg
# U2lnbmluZyBQQ0EgMjAxMTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
# AKvw+nIQHC6t2G6qghBNNLrytlghn0IbKmvpWlCquAY4GgRJun/DDB7dN2vGEtgL
# 8DjCmQawyDnVARQxQtOJDXlkh36UYCRsr55JnOloXtLfm1OyCizDr9mpK656Ca/X
# llnKYBoF6WZ26DJSJhIv56sIUM+zRLdd2MQuA3WraPPLbfM6XKEW9Ea64DhkrG5k
# NXimoGMPLdNAk/jj3gcN1Vx5pUkp5w2+oBN3vpQ97/vjK1oQH01WKKJ6cuASOrdJ
# Xtjt7UORg9l7snuGG9k+sYxd6IlPhBryoS9Z5JA7La4zWMW3Pv4y07MDPbGyr5I4
# ftKdgCz1TlaRITUlwzluZH9TupwPrRkjhMv0ugOGjfdf8NBSv4yUh7zAIXQlXxgo
# tswnKDglmDlKNs98sZKuHCOnqWbsYR9q4ShJnV+I4iVd0yFLPlLEtVc/JAPw0Xpb
# L9Uj43BdD1FGd7P4AOG8rAKCX9vAFbO9G9RVS+c5oQ/pI0m8GLhEfEXkwcNyeuBy
# 5yTfv0aZxe/CHFfbg43sTUkwp6uO3+xbn6/83bBm4sGXgXvt1u1L50kppxMopqd9
# Z4DmimJ4X7IvhNdXnFy/dygo8e1twyiPLI9AN0/B4YVEicQJTMXUpUMvdJX3bvh4
# IFgsE11glZo+TzOE2rCIF96eTvSWsLxGoGyY0uDWiIwLAgMBAAGjggHtMIIB6TAQ
# BgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQUSG5k5VAF04KqFzc3IrVtqMp1ApUw
# GQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB
# /wQFMAMBAf8wHwYDVR0jBBgwFoAUci06AjGQQ7kUBU7h6qfHMdEjiTQwWgYDVR0f
# BFMwUTBPoE2gS4ZJaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJv
# ZHVjdHMvTWljUm9vQ2VyQXV0MjAxMV8yMDExXzAzXzIyLmNybDBeBggrBgEFBQcB
# AQRSMFAwTgYIKwYBBQUHMAKGQmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kv
# Y2VydHMvTWljUm9vQ2VyQXV0MjAxMV8yMDExXzAzXzIyLmNydDCBnwYDVR0gBIGX
# MIGUMIGRBgkrBgEEAYI3LgMwgYMwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvZG9jcy9wcmltYXJ5Y3BzLmh0bTBABggrBgEFBQcC
# AjA0HjIgHQBMAGUAZwBhAGwAXwBwAG8AbABpAGMAeQBfAHMAdABhAHQAZQBtAGUA
# bgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEAZ/KGpZjgVHkaLtPYdGcimwuWEeFj
# kplCln3SeQyQwWVfLiw++MNy0W2D/r4/6ArKO79HqaPzadtjvyI1pZddZYSQfYtG
# UFXYDJJ80hpLHPM8QotS0LD9a+M+By4pm+Y9G6XUtR13lDni6WTJRD14eiPzE32m
# kHSDjfTLJgJGKsKKELukqQUMm+1o+mgulaAqPyprWEljHwlpblqYluSD9MCP80Yr
# 3vw70L01724lruWvJ+3Q3fMOr5kol5hNDj0L8giJ1h/DMhji8MUtzluetEk5CsYK
# wsatruWy2dsViFFFWDgycScaf7H0J/jeLDogaZiyWYlobm+nt3TDQAUGpgEqKD6C
# PxNNZgvAs0314Y9/HG8VfUWnduVAKmWjw11SYobDHWM2l4bf2vP48hahmifhzaWX
# 0O5dY0HjWwechz4GdwbRBrF1HxS+YWG18NzGGwS+30HHDiju3mUv7Jf2oVyW2ADW
# oUa9WfOXpQlLSBCZgB/QACnFsZulP0V3HjXG0qKin3p6IvpIlR+r+0cjgPWe+L9r
# t0uX4ut1eBrs6jeZeRhL/9azI2h15q/6/IvrC4DqaTuv/DDtBEyO3991bWORPdGd
# Vk5Pv4BXIqF4ETIheu9BCrE/+6jMpF3BoYibV3FWTkhFwELJm3ZbCoBIa/15n8G9
# bW1qyVJzEw16UM0xggTNMIIEyQIBATCBlTB+MQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5n
# IFBDQSAyMDExAhMzAAAAjoeRpFcaX8o+AAAAAACOMAkGBSsOAwIaBQCggeEwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFGB5YUqZnNDW702YAYcI6TqVJ5+cMIGABgor
# BgEEAYI3AgEMMXIwcKBIgEYAUwBlAHQALQBHAHUAZQBzAHQAQQBsAGwAbwB3AEIA
# bABvAGMAawBEAG8AbQBhAGkAbgBQAG8AbABpAGMAeQAuAHAAcwAxoSSAImh0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9leGNoYW5nZSAwDQYJKoZIhvcNAQEBBQAEggEA
# DzLlSmaJ43Ww9tMInu6PelsuK44DyKmug+CbM9BN2yYpdqDOOnu9mjR8tKV9Zzpq
# ne0n6Qurs6yMlr5OWmbCNozGTrbijzQWZiSjGO+p6aoRzg6kgNx8qScMjm44zUau
# M8viDwAhP2tG8JiiBfNWo5JwKM7tkyzyWYupzEVvCqINfoznhCS6FFHJLd87ynAF
# zjFEkNHWMZxUDa0sM0C/XqIzKKBLuQo8Ca6JBHDu9JXOZAqQ/xsnkysXSmYmZ9fP
# U1B4UjoACtgNeEA+vKEsasM1ecArqRK/JSM31p3HQOq0HWQZU0L6JH6HG3SH8YYJ
# pZQbqa3d8sQVcoDmkiR/qaGCAigwggIkBgkqhkiG9w0BCQYxggIVMIICEQIBATCB
# jjB3MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEwHwYDVQQD
# ExhNaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0ECEzMAAADKfTIWfH79BQMAAAAAAMow
# CQYFKw4DAhoFAKBdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
# AQkFMQ8XDTE3MDcyODAxNDAxNFowIwYJKoZIhvcNAQkEMRYEFKZYuhgET6OmJcVe
# hqV9u0r7hxAwMA0GCSqGSIb3DQEBBQUABIIBAEODF9PzUzMmFPgFPN+gr2Ygpjof
# GL+xyk+jmuTJzvxuTvPPN/qOq+4eFrCKHjJfHeORa/fAL8ZV0XsJqh5825hJ8z1I
# 7q1I436ukqMa8yteROeJeZY4kDiI4g8ds6qd9Meos6lo9WXIORCum4iATL7a77WZ
# jUrZcfAv96lTQizpy1rso9PXBzQO+0HrL863wyG30TjYTLiQxs6PS+Z29BGcqKi+
# uaN4FdVqbL5AC9DTddSjFqWR1xUW18FxvBbBYNZ5Nj46tnYw7dA/jUVrnDakgqNM
# o8Xd9T+BWxxUC41Na6rpqupl2kj+JZKn2HXcg8qJDIhNvNeQ/PJlW4phjac=
# SIG # End signature block
