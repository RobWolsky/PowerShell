# Load the module
Import-Module Mdbc

# Connect the new collection test.test
Connect-Mdbc . test test -NewCollection

# Add some test data
@{_id=1; value=42}, @{_id=2; value=3.14} | Add-MdbcData

# Get all data as custom objects and show them in a table
Get-MdbcData -As PS | Format-Table -AutoSize | Out-String

# Query a document by _id using a query expression
$data = Get-MdbcData (New-MdbcQuery _id -EQ 1)
$data

# Update the document, set the 'value' to 100
$data._id | Update-MdbcData (New-MdbcUpdate -Set @{value = 100})

# Query the document using a simple _id query
Get-MdbcData $data._id

# Remove the document
$data._id | Remove-MdbcData

# Count remaining documents, 1 is expected
Get-MdbcData -Count