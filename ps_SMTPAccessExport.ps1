#################################################################################################################
#                                                                                                               #
# Name:         Exporting SMTP Relay IP Addresses (only)                                                        #
# Purpose:      Exporting the allowed SMTP Relay IP Addresses for backup purposes as well as troubleshooting    #
# Output:       CSV file                                                                                        #
# Developed by: Stephen Bishop                                                                                  #
# Date:         6/7/2012                                                                                        #
#################################################################################################################
#Note has to be ran on the SMTP Relay#
Get-WmiObject -Namespace "root\MicrosoftIISv2" -Class "IIsIPSecuritySetting" -ComputerName 10.13.140.21 -Credential "global\rxw1401_e" -Property Name,IPGrant | `
where {$_.Name -eq "SmtpSvc/1"} | `
Select-Object Name,IPGrant | `
foreach  {$_.IPGrant} | Out-File "C:\Temp\Exporting SMTP Relay IP Addresses.csv" 

Get-WmiObject -Namespace Root -Class __Namespace -ComputerName 10.13.140.21 -Credential "global\rxw1401_e" | Select-Object -Property Name | Format-List

