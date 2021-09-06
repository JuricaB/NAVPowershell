#https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/quick_start/walkthrough_virtual_switch
Set-ExecutionPolicy UnRemoteSigned
$net = Get-NetAdapter -Name 'LAN'
New-VMSwitch -Name "External Lan VM Switch" -AllowManagementOS $True -NetAdapterName $net.Name

#Remove-VMSwitch -Name "DockerNAT"
#Get-VMSwitch