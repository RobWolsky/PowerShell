#Confirm SSO Configuration
Get-MSOLFederationProperty -DomainName "IFF.com"
Get-MsolDomainFederationSettings -DomainName "IFF.com"

#Confirm Exchange Certificate
Get-ExchangeCertificate | fl

# You should see the certificate you installed listed in the list of Exchange certificates returned by the Get-ExchangeCertificate cmdlet, including the parameter attributes assigned to each certificate. Verify that the certificate from the third-party trusted certificate authority (CA) that you will use for the hybrid deployment has:
# The Service attribute has the IIS and SMTP services assigned.
# The Status attribute is listed as “Valid”.
# The RootCAType attribute is listed as “ThirdParty”.

#Verify that the external URL is set on the EWS virtual directory.
Get-WebServicesVirtualDirectory "EWS (Default Web Site)" | Format-Table Name, ExternalUrl
Get-WebServicesVirtualDirectory | FL Identity,MRSProxyEnabled

#Verify that the external URL is set on the OAB virtual directory.
Get-OabVirtualDirectory "OAB (Default Web Site)" | Format-Table Name, ExternalUrl

#Verify that the external URL is set on the Microsoft-Server-ActiveSync virtual directory.
Get-ActiveSyncVirtualDirectory "Microsoft-Server-ActiveSync (Default Web Site)" | Format-Table Name, ExternalUrl

#Each of the three prior commands that you run will return the name of the virtual directory, and the value that's stored in the ExternalUrl property.
#The value stored in the ExternalUrl property should match the FQDN value that you provided when you configured the virtual directories in the wizard.

#Confirm Active Directory Synchronization
#Log in to console and manually confirm

#Confirm DNS
#Manually test nslookup to autodiscover
#Manually confirm TXT record for SPF

PS C:\Users\rxw1401> nslookup autodiscover.iff.com
Server:  usubdcp1.global.iff.com
Address:  10.29.68.10

Name:    autodiscover.iff.com
Address:  168.75.160.156


PS C:\Users\rxw1401> nslookup autodiscover.global.iff.com
Server:  usubdcp1.global.iff.com
Address:  10.29.68.10

Name:    autodiscover.global.iff.com
Address:  168.75.160.156


PS C:\Users\rxw1401> 

#Confirm Hybrid Configuration Wizard 
Get-HybridConfiguration

#To verify that EdgeSync is functioning properly, you can use the following command in the Shell on a hybrid Hub Transport server.
Test-EdgeSynchronization

#configure MX record
PS C:\Users\rxw1401> nslookup -type=MX iff.com
Server:  usubdcp1.global.iff.com
Address:  10.29.68.10

global.iff.com
	primary name server = usubdcp1.global.iff.com
	responsible mail addr = hostmaster.global.iff.com
	serial  = 8340556
	refresh = 900 (15 mins)
	retry   = 660 (11 mins)
	expire  = 86400 (1 day)
	default TTL = 3600 (1 hour)

PS C:\Users\rxw1401> 

#Test Hybrid Deployment Connectivity
#Remote Connectivity Analyzer

#Configure Network Security
#CAS accessible on Port 443 and Hub Transport Servers accessible on Port 25

#Configure Permissions in the Office 365 Tenant
#Add additional administrators as needed

#Configure Additional Remote Domains

#Configure OWA Mailbox Policies

#Configure Exchange ActiveSync Mailbox Policies

#Configure Remote Clients
#PENDING MOBILEIRON

#Export and Import Retention Tags

#UPN fix for non-routable (.local) domains
#$LocalUsers = Get-ADUser -Filter {UserPrincipalName -like '*iff.local'} -Properties userPrincipalName -ResultSetSize $null
#$LocalUsers | foreach {$newUpn = $_.UserPrincipalName.Replace("iff.local","iff.com"); $_ | Set-ADUser -UserPrincipalName $newUpn}


#Configure IRM