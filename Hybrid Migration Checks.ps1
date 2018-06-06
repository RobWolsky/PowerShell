#Check Migration Endpoint
Test-MigrationServerAvailability -ExchangeRemoteMove -RemoteServer <endpoint> -Credentials (Get-Credential) | Select Result, Message, ErrorDetail | FL *

# Microsoft Office 365 docs for Firewalls & RSS feed (IP Addresses):
https://support.office.com/en-us/article/Office-365-URLs-and-IP-address-ranges-8548a211-3fe7-47cb-abb1-355ea5aa88a2

#Troubleshooting migration issues
#Check for inbound connections:
#IIS log (2010) or HTTP Proxy (2013+) for inbound connections from mrsproxy. Diagnostic arguments are EOL and 2016 only

# Find Move Request details if move fails:
#$moveDetails = Get-MoveRequest <identity> | Get-MoveRequestStatistics -IncludeReport -Diagnostic -DiagnosticArgument Verbose
#$moveDetails | fl | more

#Look for FailureType and Message


$moveDetails = get-moverequest 'John Cassaras' | get-moverequeststatistics -IncludeReport
$moveDetails.report.sessionstatistics.sourcelatencyinfo | Fl

#Properties to investigate in detailed report
$moveDetails.report.baditems
$moveDetails.report.LargeItems
$moveDetails.report.mailboxverification

#Parse all of the Failures:

$i=0
$moveDetails.report.Failures | % {$_ | Select @{name="Index";expression={$i}},Timestamp,Failurecode,FailureType,FailureSide
$i++
} | ft

