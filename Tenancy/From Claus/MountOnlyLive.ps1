et-ExecutionPolicy RemoteSigned -force
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1'
Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\NavModelTools.ps1'


#Set Alt ID
$NAVServerInstance = "NCNZLive"
$DatabaseServer = "NCNZNAV02"
$AppDatabaseName = "NCNZLive_App"
$NavServerManagementPort = "7045"

#Nursing Council
$DatabaseName = "NCNZLive_NC"
$TenantID = "NursingCouncil"
$AlternateId = "NursingCouncil-ncnznav02.ncnz.local"

Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Chiropractic
$DatabaseName = "NCNZLive_Chiropractic"                
$TenantID = "Chiropractic"
$AlternateId = "Chiropractic-ncnznav02.ncnz.local"

Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Optometrists
$DatabaseName = "NCNZLive_Optometrists"
$TenantID = "Optometrists"
$AlternateId = "Optometrists-ncnznav02.ncnz.local"

Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Dietitians
$DatabaseName = "NCNZLive_Dietitians"
$TenantID = "Dietitians"
$AlternateId = "Dietitians-ncnznav02.ncnz.local"

Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

Set-NAVServerInstance -ServerInstance $NAVServerInstance -Restart -Force