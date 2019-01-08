et-ExecutionPolicy RemoteSigned -force
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1'
Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\NavModelTools.ps1'


#Set Alt ID
$NAVServerInstance = "NCNZLive"
$DatabaseServer = "NCNZNAV02"
$AppDatabaseName = "NCNZLive_App"
$NavServerManagementPort = "7045"

#Nursing Council
$TenantID = "NursingCouncil"
Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Chiropractic
$TenantID = "Chiropractic"         
Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Optometrists
$TenantID = "Optometrists"
Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Dietitians
$TenantID = "Dietitians"
Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force