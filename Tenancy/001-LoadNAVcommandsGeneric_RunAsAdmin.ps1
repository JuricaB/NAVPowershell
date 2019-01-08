do{
[String]$result = Read-Host "Set NAV version (80 or 90)" 
}
until(($result -eq '80') -or ($result -eq '90'))
Set-ExecutionPolicy RemoteSigned -force
[String]$Path1 = 'C:\Program Files\Microsoft Dynamics NAV\'
[String]$Path2 = 'C:\Program Files (x86)\Microsoft Dynamics NAV\'
[String]$FollowPath1 = '\Service\NavAdminTool.ps1'
[String]$FollowPath2 = '\RoleTailored Client\NavModelTools.ps1'
$Path1 = $Path1 + $result + $FollowPath1
$Path2 = $Path2 + $result + $FollowPath2
Write-Host $Path1
Write-Host $Path2

Import-Module $Path1
Import-Module $Path2