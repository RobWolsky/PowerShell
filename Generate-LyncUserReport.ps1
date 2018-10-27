<#
.NOTES
    Name: Generate-LyncUserReport
    Author: Daniel Sheehan
    Requires: PowerShell V2, Lync 2010. The account running
	this script needs to have read permissions on the RTCLocal instance 
	databases on each Lync Front-End server. A member of the 
	"RTCUniversalServerAdmins" will definitely have the necessary permissions.
	Version History:
	1.0 - 9/04/2013 - Initial release of this script.
	1.1 - 10/2/2013 - Added OU based businessCategory Admincode lookup, 
	additional error handling, and revised the SQL query to include user
	listings even if there wasn't any infomation on the last client version.
	1.2 - 10/9/2013 - Added BaseOU lookup capability to filter out users in
	the final report that are not in the designated OU path.
.SYNOPSIS
	Generates a CSV file containing the last time a Lync user connected to
	a Lync Front-End server.
.DESCRIPTION
    This script connects to the SQL instance on each Lync Front-End server
	and queries the database for the last logon informaiton of every user
	who has talked to that server. The script records the latest logon time 
	and associated client version for each user accross all of the servers.
.PARAMETER BaseOU
	This value designates the base OU to start the Lync user search in.
	If no value is defined, default to the base OU "ALL". Otherwise
    individual customer OUs can be targeted for quicker reports.
.EXAMPLE
    [PS] C:\>.\Generate-LyncUserReport.ps1 <no parameters>
    The script uses "ALL" as the base search OU for Lync users.
.EXAMPLE
	[PS] C:\>.\\Generate-LyncUserReport.ps1 -BaseOU "ALL/DEV"
	The script uses "ALL/DEV" as the base search OU for Lync users.
#>

Param (
	# Read in the -BaseOU value from the command line if one is optionally provided. Even if -BaseOU isn't used, the first value after the
	#   script name is used for this variable.
	[Parameter(Mandatory=$False, Position=0)]
	# Otherwise default to the value of "ALL".
	[String]$BaseOU = "ALL"
)

# --- Begin User Defined Variables ---
# Define the Lync Front-End servers to connect to.
$LyncServers = @("IFFANDFE01", "IFFANDFE02", "IFFANDFE03", "IFFANDFE04")
# Define the Lync report output file location and name.
$LyncReportFile =  "c:\temp\LyncUserLogonReport.CSV"
# Specify the domain name and starting location for the BaseOU value. Also replace \ character with / in the BaseOU string since only "/"
#   characters can be used in the OU path and admins tend to use the "\" character instinctively.
$SearchOU = ("global.iff.com/" + $BaseOU.Replace("\","/")) 
# --- End User Defined Variables ---

# Start tracking the time the rest of this script takes to run.
$StopWatch = New-Object System.Diagnostics.Stopwatch
$StopWatch.Start()

# Select a single domain controller to use for all the queries (to avoid mid AD replication inconsistencies) from the environment 
#   variable LOGONSERVER - this ensures the variable will always be dynamically updated to a current DC.
$DomainController = ($Env:LogonServer).Substring(2)
# Check the validity of the SearchOU based upon the BaseOU string.
If (!(Get-ADOrganizationalUnit $SearchOU -DomainController $DomainController)) {
	# Exit out of the script since there was an error with the SearchOU so a correct OU string can be entered.
	# BREAK is used in lieu of THROW since they both exit the script same way, except THROW also generates an error. Since the 
	#   Get-OrganizaitonalUnit cmdlet already generates an error, the second THROW error was unnecessary and potentially confusing.
	Write-Host -ForegroundColor Red "There was an problem with the `"$BaseOU`" AD OU path. Terminating the script."
	BREAK
}

# Import the Lync module so the Lync command Get-CsAdUser command will execute.
Import-Module Lync

# Create a Data Table, hereafter reffered to as the "user table", and add columns to hold all the Lync user information.
$LyncUserTable = New-Object System.Data.DataTable "LyncUserTable"
$LyncUserTable.Columns.Add("DisplayName",[String]) | Out-Null 
$LyncUserTable.Columns.Add("SIPAddress",[String]) | Out-Null 
$LyncUserTable.Columns.Add("Company",[String]) | Out-Null 
$LyncUserTable.Columns.Add("Department",[String]) | Out-Null 
$LyncUserTable.Columns.Add("Office",[String]) | Out-Null 
$LyncUserTable.Columns.Add("LastLogon",[String]) | Out-Null 
$LyncUserTable.Columns.Add("ClientApp",[String]) | Out-Null 
$LyncUserTable.Columns.Add("Entries",[Int]) | Out-Null 
# The SIP address is used as the primary key since it is garunteed to be unique in Lync, and a
#   key is needed so the table can be searched later.
$LyncUserTable.PrimaryKey = $LyncUserTable.Columns["SIPAddress"]

# Create a Data Table to hold all the Lync users that are ignored because they aren't in the correct OU path.
$UserIgnoreTable = New-Object System.Data.DataTable "UserIgnoreTable"
$UserIgnoreTable.Columns.Add("SIPAddress",[String]) | Out-Null
# The SIP address is used as the primary key since it is garunteed to be unique in Lync, and a
#   key is needed so the table can be searched later.
$UserIgnoreTable.PrimaryKey = $UserIgnoreTable.Columns["SIPAddress"]

# Capture the total amount of Lync servers defined Loop count to 0 for use with the progress bar below.
$LyncServerCount = $LyncServers.Count
$ServerLoopCount = 0

# Connect to and query each SQL instance through the defined Lync Front-End servers, and extract the Lync user data to the first data table
#   in a new data set.
ForEach ($LyncServer in $LyncServers) {
	$SQLQuery = "SELECT
	    HRDTBL.LastNewRegisterTime,
	    RESTBL.UserAtHost,
	    CONVERT(VARCHAR(100),RESDIRTBL.AdDisplayName) AS AdDisplayName,
	    CONVERT(VARCHAR(100),REPTBL.ClientApp) As ClientApp
	FROM
	    rtcdyn.dbo.HomedResourceDynamic HRDTBL
		INNER JOIN rtc.dbo.Resource RESTBL ON HRDTBL.OwnerId = RESTBL.ResourceId
		INNER JOIN rtc.dbo.ResourceDirectory RESDIRTBL ON HRDTBL.OwnerId = RESDIRTBL.ResourceId
	    LEFT JOIN rtcdyn.dbo.RegistrarEndpoint REPTBL ON HRDTBL.OwnerId = REPTBL.OwnerId;"
	$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
	$LyncInstance = $LyncServer + "\rtclocal"
	$SQLConnection.ConnectionString = "Data Source=$LyncInstance;Initial Catalog=rtcdyn;Integrated Security = True"
	$SQLCmd = New-Object System.Data.SqlClient.SqlCommand
	$SQLCmd.CommandText = $SQLQuery
	$SQLCmd.Connection = $SQLConnection
	$SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
	$SQLAdapter.SelectCommand = $SQLCmd
	$DataSet = New-Object System.Data.DataSet
	$SQLAdapter.Fill($DataSet) | Out-Null
	$SQLConnection.Close()
	$ServerLoopCount++
	# Set the user loop count to 0 so it can be used to track the percentage of completion of the For loop labeled as LyncUserProcessing.
	$UserLoopCount = 0
	:LyncUserProcessing ForEach ($LyncUser in $DataSet.Tables[0]) {
		$SIPAddress = $LyncUser.UserAtHost
    	$PercentComplete = [Math]::Round(($UserLoopCount++ / $DataSet.Tables[0].Rows.Count * 100),1)
		# Show a status bar for progress while the Lync user data is collected.
    	Write-Progress -Activity ("User data gathering in progress on Lync Server: $LyncServer ($ServerLoopCount of $LyncServerCount)") `
			-PercentComplete $PercentComplete -Status "$PercentComplete% Complete" -CurrentOperation "Current Lync User: $SIPAddress"
		# Filter out admin accounts that were accidentally Lync enabled, and the RtcApplication accounts.
		If (($SIPAddress -notlike "*_Admin@company.com") -and ($SIPAddress -notlike "RtcApplication*")) {
			# Search the Lync user table to see if the user's SIP address was already recorded from a previous database entry.
			If ($LyncUserTable.Rows.Find($SIPAddress)) {
				# The user was found so increment the number of found database entries for them by 1 in the Entries column.
				$LyncUserTable.Rows.Find($SIPAddress).Entries++
				# Compare the date already recorded for the user in the table to the new entry on  the Lync Front-End server.
				[datetime]$ExistingDate = $LyncUserTable.Rows.Find($SIPAddress).LastLogon
				[datetime]$CheckDate = $LyncUser.LastNewRegisterTime 
				If ($CheckDate -gt $ExistingDate) {
					# Thy database entry has a newer date than the entry in the table, so update the table entry with the newer date and
					#   associated client application information.
					$LyncUserTable.Rows.Find($SIPAddress).LastLogon = $LyncUser.LastNewRegisterTime
					$LyncUserTable.Rows.Find($SIPAddress).ClientApp = $LyncUser.ClientApp
				}
			# The user was not found in the existing user table to so search the user ignore table to see if the user's SIP address was already recorded
			#   from a previous database entry so the entry can skip further processing.
			} ElseIf (!($UserIgnoreTable.Rows.Find($SIPAddress))) {
				# The user was not found so use the Get-CsAdUser cmdlet to gather additional infomation not stored in the Lync Front-End server SQL
				#   databases, and add their information to a new row in the Lync user table. Also check to make sure the user account still exists.
				If (!($CsADUser = Get-CSADUser "sip:$SIPAddress" -OU $SearchOU -ErrorAction SilentlyContinue)) {
					# The user wasn't found in the AD SearchOU path so add them to the UserIgnoreTable and skip to the next entry in the loop.
					$UserIgnoreRow = $UserIgnoreTable.NewRow()
			        $UserIgnoreRow.SIPAddress = $SIPAddress
					# Commit the row to the user table.
			   	    $UserIgnoreTable.Rows.Add($UserIgnoreRow)
					Continue LyncUserProcessing
				}
                $LyncUserRow = $LyncUserTable.NewRow() 
                $LyncUserRow.DisplayName = $LyncUser.AdDisplayName 
                $LyncUserRow.SIPAddress = $SIPAddress 
                $LyncUserRow.Company = $CSADUser.Company 
                $LyncUserRow.Department = $CSADUser.Department 
                $LyncUserRow.Office = $CSADUser.Office 
				$LyncUserRow.LastLogon = $LyncUser.LastNewRegisterTime
				$LyncUserRow.ClientApp = $LyncUser.ClientApp
				# Since this is the first instance of a user in the table, set their found database entries to 1 entry.
				$LyncUserRow.Entries = 1
				# Commit the row to the user table.
		   	    $LyncUserTable.Rows.Add($LyncUserRow)
			}
		}
	}
}

# Close out the progress bar cleanly.
Write-Progress -Activity "User data gathering in progress on Lync Server:" -Completed -Status "Completed"

# Export the Lync user data to a CSV file.
$LyncUserTable | Sort DisplayName | Export-Csv $LyncReportFile -NoTypeInformation

# Calculate the amount of time the script took to run and write the information to the screen.
$StopWatch.Stop()
$ElapsedTime = $StopWatch.Elapsed
Write-Host "The script took" $ElapsedTime.Hours "hours," $ElapsedTime.Minutes "minutes, and" $ElapsedTime.Seconds "seconds to run."