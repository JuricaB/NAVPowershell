HowTo-ExportNAVApplicationDatabase -DatabaseServer ACJURICA -DatabaseInstance NAVDEMO -DatabaseName 'Demo Database NAV (9-0)' -DestinationDatabaseName 'NAV90App'


$NAVServerInstance = "DynamicsNAV90"
$DatabaseServer = "ACJURICA"
$DatabaseInstance = "NAVDEMO"
$AppDatabase = "NAV90App"
$NCDatabase = "Demo Database NAV (9-0)"
$NCTenantID = "NursingCouncil"


Get-NAVServerInstance

## not needed as HowTo-ExportNAVApp handles this part
#Export-NAVApplication -DatabaseServer $DatabaseServer -DatabaseName $NCDatabase -DestinationDatabaseName $AppDatabase
Set-NAVServerInstance -ServerInstance $NAVServerInstance -Stop
Remove-NAVApplication -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $NCDatabase

Set-NAVServerConfiguration -ServerInstance $NAVServerInstance -KeyName MultiTenant -KeyValue "true"
Set-NAVServerConfiguration -ServerInstance $NAVServerInstance -KeyName DatabaseName -KeyValue ""
Set-NAVServerInstance -ServerInstance $NAVServerInstance -Start
Mount-NAVApplication -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $AppDatabase

Mount-NAVTenant -DatabaseName $NCDatabase -Id $NCTenantID -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $NCTenantID 
