function New-NAVUserWithPermissions
{
    [CmdletBinding()]
    param (
        [String]$InstanceName,
        [String]$UserName,
        [String]$LicenseType,
        [String]$State,
        [String]$PermissionSetID
          )
    ##create NAV user with specified permission set ID - skip if user already exists
    $i = Get-NAVServerUser -ServerInstance $InstanceName | Where-Object -Property UserName -EQ -Value $UserName
    if ($i.UserName -ne $UserName) { 
        New-NAVServerUser -ServerInstance $InstanceName -UserName $UserName -Password (Read-Host "Enter password for $UserName" -AsSecureString) -LicenseType $LicenseType -State $State
    }
    $i = Get-NAVServerUserPermissionSet -ServerInstance $InstanceName | Where-Object -Property UserName -EQ -Value $UserName
    if ($i.UserName -ne $UserName) { 
    New-NAVServerUserPermissionSet -PermissionSetId $PermissionSetID -ServerInstance $InstanceName -UserName $UserName
    }
} 

