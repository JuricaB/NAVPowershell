$containername = 'BC245'
$dependenciesZip = "D:\Dependencies\App Dependencies 1.4.10.10 24.0 - onprem.zip"
Publish-BcContainerApp -containerName $containerName  -appFile $dependenciesZip -skipVerification -install -sync