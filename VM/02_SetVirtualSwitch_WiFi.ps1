#https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/quick_start/walkthrough_virtual_switch
$net = Get-NetAdapter -Name 'Wi-Fi'
New-VMSwitch -Name "External Wi-Fi VM Switch" -AllowManagementOS $True -NetAdapterName $net.Name

#Remove-VMSwitch -Name "External Wi-Fi VM Switch"
Remove-VMSwitch -Name "Default Switch"
#Get-VMSwitch