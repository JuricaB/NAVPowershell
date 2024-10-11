#CHANGE ME BEFORE RUNNING
$ServerInstance = "ENA241"
#CHANGE ME BEFORE RUNNING

Publish-NavContainerApp -appfile "EDITPATH\Theta Systems Limited_Integration Hub_24.0.10.0_signed.app" -skipVerification -containerName $ServerInstance -verbose
