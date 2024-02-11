# Define paths and variables
$archivePath = "C:\WinDev2401Eval.VirtualBox.zip"
$extractedPath = "C:\virtual-machines-storage"
$ovaFilePath = "C:\virtual-machines-storage\WinDev2401Eval.ova"

# Set VM name
$vmName = "WinDev2401Eval"

# Extract the zip archive
Expand-Archive -Path $archivePath -DestinationPath $extractedPath -Confirm

# Import the virtual machine to VirtualBox
VBoxManage import "$ovaFilePath"

Start-Sleep -Seconds 2

# Attach the virtual machine to grouping
VBoxManage modifyvm $vmName --groups "/Windows_VM/Win11_Normal_Use"

# Enable hot-pluggable hard disk
VBoxManage storageattach "WinDev2401Eval" --storagectl "SATA Controller" --device 0 --port 0 --type hdd --hotpluggable on

# Select USB3 Controller
VBoxManage modifyvm $vmName --usbxhci on

# Enable shared clipboard and drag-and-drop
VBoxManage modifyvm $vmName --clipboard bidirectional
VBoxManage modifyvm $vmName --draganddrop bidirectional

# Enable hardware clock in UTC time
VBoxManage modifyvm $vmName --rtcuseutc on

# Enable audio with Host Audio Driver = Windows DirectSound
VBoxManage modifyvm $vmName --audio "dsound"
VBoxManage modifyvm $vmName --audioin on
VBoxManage modifyvm $vmName --audioout on

# Change Network Adapter 1 to host-only
VBoxManage modifyvm $vmName --nic1 hostonly --hostonlyadapter1 "VirtualBox Host-Only Ethernet Adapter"

# Change Network Adapter 2 to NAT
VBoxManage modifyvm $vmName --nic2 nat

# Configure remote server
VBoxManage modifyvm $vmName --vrde on
VBoxManage modifyvm $vmName --vrdeport 5955
VBoxManage modifyvm $vmName --vrdeauthtype guest
VBoxManage modifyvm $vmName --vrdemulticon on

# Enable shared folder
VBoxManage sharedfolder add $vmName --name "virtual-machines-storage" --hostpath "C:\virtual-machines-storage" --automount
VBoxManage sharedfolder add $vmName --name "host-c" --hostpath "C:\" --automount

Write-Host "WinDev2401Eval virtual machine configuration completed."
