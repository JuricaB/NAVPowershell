Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1'
Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\NavModelTools.ps1'

#Set Alt ID
$NAVServerInstance = "NCNZTest"
$DatabaseServer = "NCNZNAV02"
$AppDatabaseName = "NCNZTest_App"
$NavServerManagementPort = "7055"

#Nursing Council
$TenantID = "NursingCouncil"
Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force
<#
#Chiropractic
$TenantID = "Chiropractic"         
Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Optometrists
$TenantID = "Optometrists"
Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Dietitians
$TenantID = "Dietitians"
Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force
#>

#Sync NAV Object manually now
#Compile-NAVApplicationObject -DatabaseName $AppDatabaseName -DatabaseServer $DatabaseServer -NavServerInstance $NAVServerInstance -NavServerManagementPort $NavServerManagementPort -NavServerName $DatabaseServer

#Nursing Council
$DatabaseName = "NCNZTest_NC"
$TenantID = "NursingCouncil"
$AlternateId = "NursingCouncilTest-ncnznav02.ncnz.local"

Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

<#
#Chiropractic
$DatabaseName = "NCNZTest_Chiropractic"                
$TenantID = "Chiropractic"
$AlternateId = "ChiropracticTest-ncnznav02.ncnz.local"

Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Optometrists
$DatabaseName = "NCNZTest_Optometrists"
$TenantID = "Optometrists"
$AlternateId = "OptometristsTest-ncnznav02.ncnz.local"

Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Dietitians
$DatabaseName = "NCNZTest_Dietitians"
$TenantID = "Dietitians"
$AlternateId = "DietitiansTest-ncnznav02.ncnz.local"

Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force
#>

Set-NAVServerInstance -ServerInstance $NAVServerInstance -Restart -Force