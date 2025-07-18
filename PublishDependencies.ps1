$containername = 'BC263'
$dependenciesZip = "D:\Dependencies\App-Dependencies-Theta Systems Limited_25.0.1.0_25.0 - OnPrem.zip"
Publish-BcContainerApp -containerName $containerName  -appFile $dependenciesZip -skipVerification -install -sync