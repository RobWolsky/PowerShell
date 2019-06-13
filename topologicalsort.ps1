#------------------------------------------------------------------------------------------
# Function: IsAccountDisabled
# Purpose: Gets state of the Active Directory User Account (True for disabled, false for
# active)
# Parameters: <distinguishedName> 
#------------------------------------------------------------------------------------------
Function IsAccountDisabled($UserDN)
{
    #Form the LDAP URL Path
    $LDAPPath = "LDAP://$UserDN"

    #Get the ADSI object of the LDAP path
    $UserObject = [ADSI] "$LDAPPath"
    
    #Get and return Account Disabled binary value (true or false)
    return $UserObject.PsBase.InvokeGet("AccountDisabled")
}


#------------------------------------------------------------------------------------------
# Function: Get-DirectReports
# Purpose: Get the direct reports employees list. If the direct report has other
# direct reports, call this function recursily to display the direct reports.
# Parameters: <User Name> or <distinguishedName>
#------------------------------------------------------------------------------------------
function get-directreports
{
    Param($user)

    #Increase the level of organization structure by one
    #Every time this function (get-directreports) called, it is processing
    #employees from an Manager
    $level++

    #Get the User object
    $userdetails = Get-ADUser $user -Properties directReports,distinguishedName
    
    #Check the account disabled or not
    $AccountStatus = IsAccountDisabled($userdetails.distinguishedName)


    if ( $AccountStatus )
    { 
        #Yes the account disabled..no need to process.
        #skipping
    }
    else
    {
        #Processing working employee (possibly an Manager)
        #Process through all direct reports of processing employee user object
        foreach( $directreport in $userdetails.directReports )
        {
            #Check the currenly processing object is Contact or not
			$adobject = get-AdObject $directreport
            If (($adobject.ObjectClass -eq "contact") -OR (IsAccountDisabled(Get-ADUser $directreport -Properties distinguishedName)))
            {
                #this current object is a contact or disabled user..do nothing.
            }
            else 
            {
                #if we are in this for loop, there is/are some direct reports for
                #the processing user object

                #Store the employee level and name to the file
                "$Script:Count.  " + ("`t" * $level) + (Get-ADUser $directreport).name + "," + (Get-ADUser -Properties DisplayName $directreport).DisplayName | Out-File -FilePath c:\Temp\OrgUsers.txt -Append

                #Display the employee organization level and name to the screen
                #("¦¦¦¦" * $level) + (Get-ADUser $directreport).name

                #Count the global employee count in this organization structure
                $Script:Count++  
            
            
                #Check the each directreport employee has other directreports
                $drdetails = get-aduser $directreport -Properties directReports

         
                if ($drdetails.directReports -eq $null) 
                {
                    #No direct reports for this employee...Do Nothing
                
                }
                else
                {
                    #There are some direct reports, so call get-directreports function (itself)
                    #to process the direct reports
                    get-directreports $drdetails.distinguishedName   
                }
            }
        }
    }

    #Decrease the level of organization structure by one
    #Every time this function quits, we are going up in the organization structure
    $level--
}





#------------------------------------------------------------------------------------------
# Name: topologicalsort.ps1
# Purpose: Get all employees working under a speific VP
# Parameters: Distinguished Name of the employee (VP or Director or Manager)
# 
# Written by: Robert Wolsky
# AD Crawl code borrowed from: Anand Venkatachalapathy
# Written Date: June 3, 2019
# Example: .\topologicalsort.ps1 "CN=vxv7417,OU=EMPLOYEE,OU=UB,OU=US,OU=NA,OU=IFF,DC=global,DC=iff,DC=com"
#------------------------------------------------------------------------------------------

#Turning off the errors and warnings.
#I am expecting some warning on contact objects in AD and other disabled accounts.
$ErrorActionPreference = "SilentlyContinue"

#Import Active Directory Module
Import-Module ActiveDirectory

#Set the organization level to 0 mean Top of the structure.
$level = 0

#Get the passed distinguished name of the employee and assign to the vairable
$DNofVP = $args[0]

#Set the employee count to 1 of this organization
$Script:Count=1

#write to file and Display the employee number 1 of this organization
"$Script:Count.  " + (Get-ADUser $DNofVP).name | Out-File -FilePath c:\Temp\OrgUsers.txt
(Get-ADUser $DNofVP).name

#Increase the employee count by 1 of this organization (before calling get-directreports
#function)
$Script:Count++

#Call the function to process the direct reports
Get-directreports $DNofVP

#Turn on displaying errors and warnings
$ErrorActionPreference = "Continue"

#--------------------------- End of Script ----------------------------------------
