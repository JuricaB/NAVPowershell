Set-ExecutionPolicy RemoteSigned -force
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1'
Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\NavModelTools.ps1'

Import-Module 'F:\Software\Dynamics NAV 2015 CU4\481965_ENU_i386_zip\NAV.8.0.39663.NZ.DVD\WindowsPowerShellScripts\Multitenancy\NAVMultitenancySamples.psm1'
Import-Module 'F:\Software\Dynamics NAV 2015 CU4\481965_ENU_i386_zip\NAV.8.0.39663.NZ.DVD\WindowsPowerShellScripts\Multitenancy\HowTo-MoveCompanyToTenant.ps1'


Import-NAVServerLicense -LicenseFile "C:\Users\acumen\Desktop\NCNZ Licenses\2015-03-26 NCNZ NAV 2015.flf" -ServerInstance NCNZTest -Tenant NC -Database Tenant
Import-NAVServerLicense -LicenseFile "C:\Users\acumen\Desktop\T167.fob" -ServerInstance NCNZTest -Tenant Cronus -Database Tenant
Set-NAVServerInstance -ServerInstance NCNZTest -Restart -Force

How-to

Get-NAVTenant -ServerInstance NCNZLive | Get-NAVServerSession -ServerInstance NCNZLive | Format-Table -AutoSize UserID, DatabaseName, LoginDateTime

Get-NAVTenant -ServerInstance NCNZTest


#Set Alt ID
$NAVServerInstance = "NCNZLive"
$DatabaseServer = "NCNZNAV02"

$DatabaseName = "NCNZLive_Chiropractic"                
$TenantID = "Chiropractic"
$AlternateId = "Chiropractic-ncnznav02.ncnz.local"

Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Service user must be db owner to amount database
Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

$DatabaseName = "NCNZLive_Optometrists"
$TenantID = "Optometrists"
$AlternateId = "Optometrists-ncnznav02.ncnz.local"

Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Service user must be db owner to amount database
Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

$DatabaseName = "NCNZLive_Dietitians"
$TenantID = "Dietitians"
$AlternateId = "Dietitians-ncnznav02.ncnz.local"

Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Service user must be db owner to amount database
Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

Set-NAVServerInstance -ServerInstance $NAVServerInstance -Restart -Force

#$DatabaseName = "NCNZTest_NC"
#$TenantID = "NursingCouncil"
#$AlternateId = "NursingCouncilTest-ncnznav02.ncnz.local"

Dismount-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force

#Service user must be db owner to amount database
Mount-NAVTenant -DatabaseName $DatabaseName -Id $TenantID -AlternateId $AlternateId  -ServerInstance $NAVServerInstance -DatabaseServer $DatabaseServer -OverwriteTenantIdInDatabase
Sync-NAVTenant -ServerInstance $NAVServerInstance -Tenant $TenantID -Force
Set-NAVServerInstance -ServerInstance $NAVServerInstance -Restart -Force


Get-NAVTenant -ServerInstance $NAVServerInstance


Sync-NAVTenant -ServerInstance NCNZLive -Tenant Dietitians

Get-NAVTenant -ServerInstance NCNZLive | Get-NAVServerSession 

New-NAVServerUser -ServerInstance NCNZLive -WindowsAccount NCNZ\Acumen -FullName Acumen -Tenant Dietitians
New-NAVServerUserPermissionSet -PermissionSetId SUPER -ServerInstance NCNZLive -WindowsAccount NCNZ\Acumen -Tenant Dietitians


Get-NAVTenant -ServerInstance NCNZLive | Get-NAVServerSession | Select UserID, DatabaseName | Format-Table