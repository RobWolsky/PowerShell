# FileName:  ps_TESTGraphAPI.ps1
#----------------------------------------------------------------------------
# Script Name: [Pull all Plans, Buckets, and Tasks from Teams]
# Created: [03/06/2019]
# Author: Rob Wolsky
# Company: International Flavors & Fragrances
# Email: rob.wolsky@iff.com
# Requirements: Requires Office 365 Group ID to define search scope
# Requirements: 
# Requirements: 
# Keywords:
#-----------------------------------------------------------------------------
# Purpose: Create a consolidated view of tasks across multiple channels
#-----------------------------------------------------------------------------
# REVISION HISTORY
#-----------------------------------------------------------------------------
# Date: [03/06/2019]
# Time: [13:31]
# Issue: Initial Development 
# Solution:
#
#-----------------------------------------------------------------------------
# Script Body - Main script section
#-----------------------------------------------------------------------------

#access graph application
$username = '599f2f05-2b85-4d68-93fe-4c46a659479c'
$password = ']c-@/|$N>|kO$n:-:=-6.M@' | ConvertTo-SecureString -AsPlainText -Force
$ClientCredential = New-Object -TypeName System.Management.Automation.PSCredential($username,$password)
$GraphAppParams = @{}
$GraphAppParams.Add('Name','Office365TenantMigration')
$GraphAppParams.Add('ClientCredential',$ClientCredential)
$GraphAppParams.Add('RedirectUri','https://login.microsoftonline.com/common/oauth2/nativeclient')
$GraphAppParams.Add('Tenant','iff.onmicrosoft.com')

$GraphApp = New-GraphApplication @GraphAppParams 
# This will prompt you to log in with your O365/Azure credentials. 
$AuthCode = $GraphApp | Get-GraphOauthAuthorizationCode 
$GraphAccessToken = $AuthCode | Get-GraphOauthAccessToken -Resource 'https://graph.microsoft.com/'
$GraphAccessToken | Export-GraphOAuthAccessToken -Path 'c:\Temp\AccessToken.XML'
$GraphAccessToken =  Import-GraphOAuthAccessToken -Path 'c:\Temp\AccessToken.XML'
$GraphAccessToken | Update-GraphOAuthAccessToken -Force

#Initialize array variable used to store records for output
$arrResults = @()

#Initialize array variable used to store Plan records
$plans = @()
$buckets = @()
$tasks = @()
$details = @()

#Initialize array variable used to store records for output
$arrResults = @()

#Populate Arrays with Plans, Buckets, Tasks, and Task Details
#Requirement is Office 365 Group ID

$p = Invoke-GraphRequest -Uri https://graph.microsoft.com/v1.0/groups/32fe1fd8-02df-4721-a005-876054cdf0a9/planner/plans -Method GET -AccessToken $GraphAccessToken
$plans = $p.result.content | ConvertFrom-Json | select -expand value | select id, title

ForEach ($plan in [Array] $plans)
{
    $uri = "https://graph.microsoft.com/v1.0/planner/plans/" + $plan.id + "/buckets"
    $b = Invoke-GraphRequest -Uri $uri -Method GET -AccessToken $GraphAccessToken
    $buckets = $b.result.content | ConvertFrom-Json | select -expand value | select id, name
    
    ForEach ($bucket in [Array] $buckets)
    {
        $uri = "https://graph.microsoft.com/v1.0/planner/buckets/" + $bucket.id + "/tasks"
        $t = Invoke-GraphRequest -Uri $uri -Method GET -AccessToken $GraphAccessToken
        $tasks = $t.result.content | ConvertFrom-Json | select -expand value | select id, title, hasDescription, startDateTime, percentComplete, completeDateTime
    
        ForEach ($task in [Array] $tasks)
        {
        $users = $t.result.content | ConvertFrom-Json | select -expand value | select -expand assignments | get-member -Type NoteProperty
                #add a condition, if no user output the task            
                ForEach ($user in [Array] $users)
                {
                $uri = "https://graph.microsoft.com/v1.0/users/" + $user.name
                $d = Invoke-GraphRequest -Uri $uri -Method GET -AccessToken $GraphAccessToken
                $display = $d.result.content | ConvertFrom-Json | Select DisplayName
                #Process for output
                $objEX = [PSCustomObject]@{

                Plan                = $plan.title
                Bucket              = $bucket.name
                Task                = $task.id
                TaskTitle           = $task.title
                Assigned            = $display.displayName
                TaskDescription     = $task.hasDescription
                TaskStart           = $task.startDateTime
                TaskPercent         = $task.percentComplete
                TaskComplete        = $task.completeDateTime
                }
                $arrResults += $objEX
                }
            }

    }
}
$arrResults | Out-GridView

<#
$b = Invoke-GraphRequest -Uri https://graph.microsoft.com/v1.0/planner/plans/UFAEkZ4YJkGi3WA97tUoI2QAEEL9/buckets -Method GET -AccessToken $GraphAccessToken
$t = Invoke-GraphRequest -Uri https://graph.microsoft.com/v1.0/planner/tasks/ICgDFyNHl0KgJ3NLvBNeImQALHld -Method GET -AccessToken $GraphAccessToken
$d = Invoke-GraphRequest -Uri https://graph.microsoft.com/v1.0/planner/tasks/ICgDFyNHl0KgJ3NLvBNeImQALHld/details -Method GET -AccessToken $GraphAccessToken
#>
#$b.result.content | ConvertFrom-Json | select -expand value | select id, name
#$d.result.content | ConvertFrom-Json | select description


#Initialize array variable used to store records for output
<#
Write-Host -ForegroundColor Green "Processing user objects."
Write-Host -ForegroundColor Green "$($identities.Count) objects in scope."
	
$arrResults = @()

    #Process for output

    $objEX = New-Object -TypeName PSObject
        
    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $User.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name ID -Value $User.Name

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $User.UserPrincipalName

    $objEX | Add-Member -MemberType NoteProperty -Name DN -Value $User.DistinguishedName

    $objEX | Add-Member -MemberType NoteProperty -Name License -Value "NOT SYNCHED TO MSOL"

    
    $arrResults += $objEX 
    ; continue}
    if ($verify.isLicensed -eq $false) {
    #Write-Host -BackgroundColor Red "User $($User.UserPrincipalName) not licensed"
    #Process for output

    $objEX = New-Object -TypeName PSObject
        
    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $User.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name ID -Value $User.Name

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $User.UserPrincipalName

    $objEX | Add-Member -MemberType NoteProperty -Name DN -Value $User.DistinguishedName

    $objEX | Add-Member -MemberType NoteProperty -Name License -Value "UNLICENSED"

    
    $arrResults += $objEX 
    ; continue}
    
    $Got = $verify | Select-Object -ExpandProperty Licenses
        ForEach ($License in [Array] $Got)
{       $OutSKU = $License.AccountSKUID
        

	
 #Process for output

    $objEX = New-Object -TypeName PSObject
        
    $objEX | Add-Member -MemberType NoteProperty -Name User -Value $User.DisplayName

    $objEX | Add-Member -MemberType NoteProperty -Name ID -Value $User.Name

    $objEX | Add-Member -MemberType NoteProperty -Name UPN -Value $User.UserPrincipalName
    
    $objEX | Add-Member -MemberType NoteProperty -Name DN -Value $User.DistinguishedName

    $objEX | Add-Member -MemberType NoteProperty -Name License -Value $OutSku

    
    $arrResults += $objEX 

}
}

$arrResults | Out-GridView


#-----------------------------------------------------------------------------
# END OF SCRIPT: [Find all assigned licenses in client tenant]
#-----------------------------------------------------------------------------
#>
