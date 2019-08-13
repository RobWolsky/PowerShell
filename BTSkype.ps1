####Add users to OKTA group for BT Sync
#Add-ADGroupMember -Identity "okta_all_iff_users_hr" -Members $member



    function Add-BTSkype

    {
        Param (
        
        [Parameter(Mandatory=$true)]
        [string] $BTUser,
        [string] $SipAddress #In the form of "SIP:EmailAddress"
        
        )
        
        $Credential = Get-Credential

        #IFFOCM AD Server - LyncDiscoverInternal DNS points to this first
        $server= "ifflondc02.iffocm.com"

        set-aduser $BTUser -add @{'msRTCSIP-DeploymentLocator'= "sipfed.online.lync.com"} -Server $server -Credential $Credential
        set-aduser $BTUser -add @{'msRTCSIP-FederationEnabled'=$true} -Server $server -Credential $Credential
        set-aduser $BTUser -add @{'msRTCSIP-InternetAccessEnabled'=$true} -Server $server -Credential $Credential
        set-aduser $BTUser -add @{'msRTCSIP-OptionFlags' = "257"} -Server $server -Credential $Credential
        set-aduser $BTUser -add @{'msRTCSIP-PrimaryUserAddress'= "$SIPAddress"} -Server $server -Credential $Credential
        set-aduser $BTuser -add @{'msRTCSIP-UserEnabled' = $true} -Server $server -Credential $Credential
    
    
        
        
        }

        #Add-BTSkype -BTUser axy2073 -SipAddress Agnes.Yeo.XinEe@iff.com
