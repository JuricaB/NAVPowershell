function Get-NAVDatabaseServerName
{
    [CmdletBinding()]
    param (
        [String]$ServerInstance
          )

$DatabaseServer = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "DatabaseServer" 
$DatabaseInstance = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "DatabaseInstance" 
$DatabaseName = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "DatabaseName"
If ($DatabaseInstance.Value  -ne "") 
    {$DatabaseServer.Value = $DatabaseServer.Value + "\" + $DatabaseInstance.Value}
Write-Host $ServerInstance
Write-Host $DatabaseServer.Value
Write-Host $DatabaseName.Value
}