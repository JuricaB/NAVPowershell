function Get-NAVDatabaseServerName
{
    [CmdletBinding()]
    param (
        [String]$ServerInstance
          )

$object = New-Object –TypeName PSObject


$DatabaseServer = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "DatabaseServer" 
$DatabaseInstance = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "DatabaseInstance" 
$DatabaseName = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "DatabaseName"

$ClientPort = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "ClientServicesPort"
$SOAPPort = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "SOAPServicesPort"
$ODataPort = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "ODataServicesPort"
$ManagementPort = Get-NAVServerConfiguration2 $ServerInstance | where Key -EQ "ManagementServicesPort"

If ($DatabaseInstance.Value  -ne "") 
    {$DatabaseServer.Value = $DatabaseServer.Value + "\" + $DatabaseInstance.Value}

$object | Add-Member –MemberType NoteProperty –Name ServiceInstance –Value $DatabaseServer.ServiceInstance
$object | Add-Member –MemberType NoteProperty –Name DatabaseServerInstance –Value $DatabaseServer.Value
$object | Add-Member –MemberType NoteProperty –Name DatabaseName –Value $DatabaseName.Value

$object | Add-Member –MemberType NoteProperty –Name ClientPort –Value $ClientPort.Value
$object | Add-Member –MemberType NoteProperty –Name SOAPPort –Value $SOAPPort.Value
$object | Add-Member –MemberType NoteProperty –Name ODataPort –Value $ODataPort.Value
$object | Add-Member –MemberType NoteProperty –Name ManagementPort –Value $ManagementPort.Value

Write-Output $object
}