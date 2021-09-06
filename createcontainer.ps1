$containerName = 'bc182'
$password = $containerName
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'Sandbox' -country 'nz' -select 'Latest'
$licenseFile = 'C:\Job\License\BCDEV.flf'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName 'myimage' `
    -assignPremiumPlan `
    -licenseFile $licenseFile `
    -includeAL `
    -vsixFile (Get-LatestAlLanguageExtensionUrl) `
    -updateHosts
