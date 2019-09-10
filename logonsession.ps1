Get-CimInstance -ClassName Win32_Logonsession |
Where-Object LogonType -in @(2,10) |
ForEach-Object {
    
     switch ($_.LogonType){
          2 {$type = ‘Interactive Session’}
         10 {$type = ‘Remote Session’}
         default {throw “Broken! Unrecognised logon type” }
     }

    $usr = Get-CimAssociatedInstance -InputObject $psitem -ResultClassName Win32_Account
     $props = [ordered]@{
         Name = $usr.Name
         Domain = $usr.Domain
         SessionType = $type
         LogonTime = $_.StartTime
         Authentication = $_.AuthenticationPackage
         Local = $usr.LocalAccount
     }
     if ($props.Name) {New-Object -TypeName PSobject -Property $props}
}