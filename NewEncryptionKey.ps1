clear
$version = '{BCVERSION}'
$InstanceName = '{BCINSTANCE}'
$DatabaseServer = '{DBSERVER}'
$DatabaseName = '{DBNAME}'
$DatabaseUserName = '{DBUSER}'
$DatabasePassword = '{DBPASSWORD}'
$ImportUserName = '{SQLADMIN}'
$ImportPassword = '{SQLADMINPASSWORD}'
$KeyFilePath = Join-Path (Get-Location) "$InstanceName.key"
Set-ExecutionPolicy unrestricted -Force
Import-Module "$Env:Programfiles\Microsoft Dynamics 365 Business Central\$version\Service\NavAdminTool.ps1" -Force -ErrorAction Stop > $null

$KeyCredential = (New-Object PSCredential -ArgumentList $DatabaseUserName,(ConvertTo-SecureString -AsPlainText -Force $DatabasePassword))

$ImportCredential = (New-Object PSCredential -ArgumentList $ImportUserName,(ConvertTo-SecureString -AsPlainText -Force $ImportPassword))

New-NAVEncryptionKey -KeyPath $KeyFilePath -Password $KeyCredential.Password

Import-NAVEncryptionKey -ApplicationDatabaseCredentials $KeyCredential -ApplicationDatabaseServer $DatabaseServer -ApplicationDatabaseName $DatabaseName -KeyPath $KeyFilePath -ServerInstance $InstanceName -Password $KeyCredential.Password -Force

Set-NAVServerConfiguration -DatabaseCredentials $KeyCredential -ServerInstance $InstanceName -Force > $null