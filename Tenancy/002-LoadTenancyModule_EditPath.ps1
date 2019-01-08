[String]$Path =  'C:\Users\Juricab\Documents\Tools\Powershell in NAV\Tenancy\Multitenancy\'
[String]$MultitenantModule = 'NAVMultitenancySamples.psm1'
$Path = $Path + $MultitenantModule
Import-Module $Path
