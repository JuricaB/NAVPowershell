function New-NAVUserWithPermissionsInRunningInstances
{
    [CmdletBinding()]
    param (
        [String]$WindowsAccount,
        [String]$LicenseType,
        [String]$State,
        [String]$PermissionSetID
          )
   ## creates user and assigns permission set ID in all running instances on server where it does not already exist
   $Instances = Get-NAVServerInstance | Where-Object -Property State -EQ -Value Running  
   $Instances | ForEach-Object -Process {New-NAVWinUserWithPermission -InstanceName $_.ServerInstance -WindowsAccount $WindowsAccount -LicenseType $LicenseType -State $State -PermissionSetID $PermissionSetID}

} 

