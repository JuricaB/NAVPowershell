##Script for NursingCouncil - moving companies to separate tenants databases
##assumes unique first parts of Company Names to be moved

##constants
$ServerInstance = 'DynamicsNAV90'
$SourceDatabaseName = 'Demo Database NAV (9-0)'
$SourceCompanyName = 'Occupational Therapy'
$OldTenantID = 'nursingcouncil'
$ServiceAccount = 'NT AUTHORITY\NETWORK SERVICE'
$DatabaseServer = 'ACJURICA'
$DatabaseInstance = 'NAVDEMO'
$TargetDatabaseNamePrefix = 'NCNZLive_'
$AlternateIDSuffix = '-ncnznav02.ncnz.local'

##calculated values
#Use first part of full company name to reduce errors
$pos = $SourceCompanyName.IndexOf(" ")
If($pos -eq -1)
    {$ShortName = $SourceCompanyName}
Else
    {$ShortName = $leftPart = $SourceCompanyName.Substring(0, $pos)}
#Lowercase ShortName to reduce errors

$NewTenantID = $ShortName.ToLower() 

If($DatabaseInstance -ne '') 
    {$DatabaseServerInstance = $DatabaseServer + '\' + $DatabaseInstance}
Else
    {$DatabaseServerInstance = $DatabaseServer}
$TargetDatabaseName = $TargetDatabaseNamePrefix + $ShortName
$AlternateID = $ShortName + $AlternateIDSuffix

#Create tenant database, assign permissions, copy data to tenant DB and mount tenant
HowTo-MoveCompanyToTenant -ServerInstance $ServerInstance -FromDatabase $SourceDatabaseName -CompanyName $SourceCompanyName -OldTenantName $OldTenantID -NewTenantName $NewTenantID -ServiceAccount $ServiceAccount -DatabaseServer $DatabaseServerInstance -ToDatabase $TargetDatabaseName

#dismount tenant and remount it to add AlternateID
Dismount-NAVTenant -ServerInstance $ServerInstance -Tenant $NewTenantID
Mount-NAVTenant -DatabaseName $TargetDatabaseName -Id $NewTenantID -ServerInstance $ServerInstance -AlternateId $AlternateID -DatabaseInstance $DatabaseInstance -DatabaseServer $DatabaseServer

#Remove company from original tenant
Remove-NAVCompany -CompanyName $SourceCompanyName -ServerInstance $ServerInstance -Tenant $OldTenantID