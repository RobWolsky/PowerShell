$ou = Get-EXLOrganizationalUnit -SearchText "EMPLOYEE" | ? {($_.CanonicalName | Out-String) -notlike "*NO**"} | Select DistinguishedName | Sort-Object CanonicalName
foreach ($o in $ou){
   get-aduser -Filter * -ResultSetSize 1000 -SearchBase $o.DistinguishedName | Select name | 

}
