cd "C:\Program Files\Microsoft Dynamics NAV\110\Service"
Import-Module ".\Microsoft.Dynamics.Nav.Apps.Management.psd1"

Publish-NAVApp -ServerInstance DynamicsNAV110 -PackageType Extension -SkipVerification -Path "EDITPATH\Theta Systems Limited_Integration Hub_22.0.3.12.app" -verbose
Sync-NAVApp -ServerInstance DynamicsNAV110 -Mode Add -Name "Integration Hub" -Version 22.0.3.12 -verbose
#Install-NAVApp -ServerInstance DynamicsNAV110 -Name "Integration Hub" -Version 22.0.3.11	-verbose