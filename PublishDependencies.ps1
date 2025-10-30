$containername = 'BC265'
$dependenciesZip = "D:\Dependencies\OnPrem-App-Dependencies and Admin Tools_25.2.0.0.zip"
Publish-BcContainerApp -containerName $containerName  -appFile $dependenciesZip -skipVerification -install -sync