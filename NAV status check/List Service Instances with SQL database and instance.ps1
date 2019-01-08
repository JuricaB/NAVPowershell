$Instances = Get-NAVServerInstance 
$Instances | ForEach-Object -Process {Get-NAVDatabaseServerName -ServerInstance $_.ServerInstance } |Format-Table -AutoSize
