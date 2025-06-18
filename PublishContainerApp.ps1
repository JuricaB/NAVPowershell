#CHANGE ME BEFORE RUNNING
$ServerInstance = "BC250"
#CHANGE ME BEFORE RUNNING

Publish-BCContainerApp -appfile "C:\Users\Jurica.Bogunovic\Downloads\Theta Systems Limited_Integration Hub (PTE)_23.0.10.0.app" -skipVerification -containerName $ServerInstance -verbose
