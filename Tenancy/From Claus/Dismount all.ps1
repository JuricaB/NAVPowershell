#Set Alt ID
$NAVServerInstance = "NCNZLive"
$DatabaseServer = "NCNZNAV02"

#Nursing Council
$DatabaseName = "NCNZLive_NC"
$TenantID = "NursingCouncil"
$AlternateId = "NursingCouncil-ncnznav02.ncnz.local"

Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force
Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

Set-NAVServerInstance -ServerInstance $NAVServerInstance -Restart -Force

#Chiropractic
$DatabaseName = "NCNZLive_Chiropractic"                
$TenantID = "Chiropractic"
$AlternateId = "Chiropractic-ncnznav02.ncnz.local"

Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force
Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Optometrists
$DatabaseName = "NCNZLive_Optometrists"
$TenantID = "Optometrists"
$AlternateId = "Optometrists-ncnznav02.ncnz.local"

Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force
Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Dietitians
$DatabaseName = "NCNZLive_Dietitians"
$TenantID = "Dietitians"
$AlternateId = "Dietitians-ncnznav02.ncnz.local"

Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force
Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

Set-NAVServerInstance -ServerInstance $NAVServerInstance -Restart -Force
