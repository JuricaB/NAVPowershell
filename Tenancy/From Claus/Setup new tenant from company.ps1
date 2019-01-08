Set-ExecutionPolicy RemoteSigned -force
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\80\Service\NavAdminTool.ps1'
Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\NavModelTools.ps1'

Import-Module 'F:\Software\Dynamics NAV 2015 CU4\481965_ENU_i386_zip\NAV.8.0.39663.NZ.DVD\WindowsPowerShellScripts\Multitenancy\NAVMultitenancySamples.psm1'
Import-Module 'F:\Software\Dynamics NAV 2015 CU4\481965_ENU_i386_zip\NAV.8.0.39663.NZ.DVD\WindowsPowerShellScripts\Multitenancy\HowTo-MoveCompanyToTenant.ps1'

#RA Tenant
#code creates new tenant databae, copies company to new tenant database and mounts new tenant database to server
$MoveCompanyName = "RA Template"
$FromDatabase = "NCNZLive_NC"
$OldTenantName = "NursingCouncil"

$DatabaseServer = "NCNZNAV02"
$ServerInstance = "NCNZLive"
$ServiceAccount = "NCNZ\NAVservice"

$ToTenantID = "Psychotherapists"
$NewTenantName = "Psychotherapists"
$ToDatabase = "NCNZLive_Psychotherapists"


HowTo-MoveCompanyToTenant -CompanyName $MoveCompanyName -FromDatabase $FromDatabase -NewTenantName $ToTenantID `
                          -OldTenantName $OldTenantName -ServerInstance $ServerInstance -DatabaseServer $DatabaseServer `
                          -ToDatabase $ToDatabase -ServiceAccount $ServiceAccount

$NewCompanyName = "Psychotherapists Board"
Rename-NAVCompany -CompanyName $MoveCompanyName -NewCompanyName $NewCompanyName -ServerInstance $ServerInstance `
                  -Tenant $NewTenantName

