$NAVServerInstance = "NCNZLive"
$DatabaseServer = "NCNZNAV02"
$AppDatabase = "NCNZLive_App"
$NCDatabase = "NCNZLive_NC"
$NCTenantID = "NursingCouncil"


Get-NAVServerInstance

Export-NAVApplication -DatabaseServer $DatabaseServer -DatabaseName $NCDatabase -DestinationDatabaseName $AppDatabase
Set-NAVServerInstance -ServerInstance $NAVServerInstance -Stop
Remove-NAVApplication -DatabaseServer $DatabaseServer -DatabaseName $NCDatabase

Set-NAVServerConfiguration -ServerInstance $NAVServerInstance -KeyName MultiTenant -KeyValue "true"
Set-NAVServerConfiguration -ServerInstance $NAVServerInstance -KeyName DatabaseName -KeyValue ""
Set-NAVServerInstance -ServerInstance $NAVServerInstance -Start
Mount-NAVApplication -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -DatabaseName $AppDatabase

Mount-NAVTenant -DatabaseName $NCDatabase -Id $NCTenantID -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $NCTenantID 



#RA Tenant
#code creates new tenant databae, copies company to new tenant database and mounts new tenant database to server
$DatabaseServer = "NCNZNAV02"
$CompanyName = "RA Template"
$ToTenantID = "Chiropractic"
$NewTenantName = "Chiropractic"
$ToDatabase = "NCNZLive_Chiropractic"

HowTo-MoveCompanyToTenant -CompanyName "RA Template" -FromDatabase NCNZLive_NC -NewTenantName $ToTenantID -OldTenantName NursingCouncil -ServerInstance NCNZLive -DatabaseServer $DatabaseServer -ToDatabase $ToDatabase -ServiceAccount "NCNZ\NAVservice"









$TenantDatabase = "NCNZLive_Dietitians"
$TenantID = "Dietitians"

Remove-NAVApplication -DatabaseServer $DatabaseServer -DatabaseName $CronusDatabase

Mount-NAVTenant -DatabaseName $CronusDatabase -Id $TenantIDCronus -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantIDCronus 

Get-NAVTenant -ServerInstance $NAVServerInstance


Sync-NAVTenant -ServerInstance NCNZLive -Tenant Dietitians
Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant Dietitians