#todo - handle multiple builds by adding build to the full paths
do{
[String]$result = Read-Host "Set NAV version (71,80,90,100,110,130)" 
}
until(($result -eq '71') -or ($result -eq '80') -or ($result -eq '90') -or ($result -eq '100') -or ($result -eq '110') -or ($result -eq '130'))
Set-ExecutionPolicy RemoteSigned -force
if ($result -eq '130')
    {
        [String]$Path1 = 'C:\Program Files\Microsoft Dynamics 365 Business Central\'
        [String]$Path2 = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\'
    }
else
    {
        [String]$Path1 = 'C:\Program Files\Microsoft Dynamics NAV\'
        [String]$Path2 = 'C:\Program Files (x86)\Microsoft Dynamics NAV\'
    }

[String]$FollowPath1 = '\Service\NavAdminTool.ps1'
[String]$FollowPath2 = '\RoleTailored Client\NavModelTools.ps1'
[String]$FollowPath3 = '\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1'
[String]$FollowPath4 = '\RoleTailored Client\finsql.exe'

$FullPath1 = $Path1 + $result + $FollowPath1 #admin tools
$FullPath2 = $Path2 + $result + $FollowPath2 #NAVModelTools
$FullPath3 = $Path2 + $result + $FollowPath3 #IDE psm
$FullPath4 = $Path2 + $result + $FollowPath4 #finsql

if([System.IO.File]::Exists($FullPath1))
    {
        Write-Host 'Importing module: ' $FullPath1    
        Import-Module $FullPath1
    }
else
    {
        Write-Host 'File not found: ' $FullPath1
    }

if([System.IO.File]::Exists($FullPath2))
    {
        Write-Host 'Importing module: ' $FullPath2    
        Import-Module $FullPath2
    }
else
    {
        Write-Host 'File not found: ' $FullPath2
    }

if([System.IO.File]::Exists($FullPath3))
    {
        Write-Host 'Importing module: ' $FullPath3    
        Import-Module $FullPath3
    }
else
    {
        Write-Host 'File not found: ' $FullPath3
    }

if([System.IO.File]::Exists($FullPath4))
    {
        Write-Host 'Setting NAV IDE: ' $FullPath4
        $NavIde= $FullPath4
    }
else
    {
        Write-Host 'File not found: ' $FullPath4
    }