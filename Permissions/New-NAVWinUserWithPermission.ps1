function New-NAVWinUserWithPermissions
{
    [CmdletBinding()]
    param (
        [String]$InstanceName,
        [String]$WindowsAccount,
        [String]$LicenseType,
        [String]$State,
        [String]$PermissionSetID
          )
    ##create NAV user with specified permission set ID - skip if user already exists
    $i = Get-NAVServerUser -ServerInstance $InstanceName | Where-Object -Property UserName -EQ -Value $WindowsAccount
    if ($i.UserName -ne $WindowsAccount) { 
        New-NAVServerUser -ServerInstance $InstanceName -WindowsAccount $WindowsAccount -LicenseType $LicenseType -State $State
    }
    $i = Get-NAVServerUserPermissionSet -ServerInstance $InstanceName | Where-Object -Property UserName -EQ -Value $WindowsAccount
    if ($i.UserName -ne $WindowsAccount) { 
    New-NAVServerUserPermissionSet -PermissionSetId $PermissionSetID -ServerInstance $InstanceName -WindowsAccount $WindowsAccount
    }
} 

