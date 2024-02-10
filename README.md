
# Setup Win11 VM in Virtualbox

```markdown
> Austin.Lai |
> -----------| February 10th, 2024
> -----------| Updated on February 10th, 2024
```

---

## Table of Contents

<!-- TOC -->

- [Setup Win11 VM in Virtualbox](#setup-win11-vm-in-virtualbox)
    - [Table of Contents](#table-of-contents)
    - [Disclaimer](#disclaimer)
    - [Description](#description)
    - [virtualbox import and modifyvm powershell script](#virtualbox-import-and-modifyvm-powershell-script)

<!-- /TOC -->

<br>

## Disclaimer

<span style="color: red; font-weight: bold;">DISCLAIMER:</span>

This project/repository is provided "as is" and without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

This project/repository is for <span style="color: red; font-weight: bold;">Educational</span> purpose <span style="color: red; font-weight: bold;">ONLY</span>. Do not use it without permission. The usual disclaimer applies, especially the fact that me (Austin) is not liable for any damages caused by direct or indirect use of the information or functionality provided by these programs. The author or any Internet provider bears NO responsibility for content or misuse of these programs or any derivatives thereof. By using these programs you accept the fact that any damage (data loss, system crash, system compromise, etc.) caused by the use of these programs is not Austin responsibility.

<br>

## Description

<!-- Description -->

This project/repository is a local setup of <span style="color: red; font-weight: bold;">Win11 VM in Virtualbox</span>.

<span style="color: orange; font-weight: bold;">Note:</span>

- The configurations in this project/repository are for your reference ONLY (the reasons are as follows):
    - The setup is hosted in <span style="color: green; font-weight: bold;">Virtual Machine</span> environment, leveraging <span style="color: green; font-weight: bold;">Virtualbox</span> on a <span style="color: green; font-weight: bold;">Windows</span> host.
    - You can download Win11 Virtualbox VM from [Official Windows 11 development environment Virtual Machines](https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/).
    - This setup require you to configure two network interfaces for the Win11 Virtualbox VM:

        1. VirtualBox Host-Only Ethernet Adapter (192.168.56.0/24)
        2. NAT

    - This setup has a `virtualbox-import-and-modifyvm` powershell script:
        - [virtualbox import and modifyvm powershell script](#virtualbox-import-and-modifyvm-powershell-script)

    - Please change the configuration accordingly to suits your hosting environment.

<!-- /Description -->

<br>

## virtualbox import and modifyvm powershell script

This powershell script will extract the Win11 VirtualBox VM archive to the specified folder and import to VirtualBox.

Then, it will change the configuration accordingly:

- Enable Hot-Pluggable HHD
- Use USB3 instead of USB1
- Enable clipboard and drag-and-drop functionality with cidirectional
- Enable hardware clock in UTC time
- Enable audio with "dsound" driver along with audio input and audio output
- Set Network Adapter 1 to "VirtualBox Host-Only Ethernet Adapter"
- Set Network Adapter 2 to "NAT"
- Enable Remote Display Server with port 5955 and use "guest" authentication method
- Enable share folder with auto-mount

The `virtualbox-import-and-modifyvm.ps1` file can be found [here](virtualbox-import-and-modifyvm.ps1) or below:

<details>

<summary><span style="padding-left:10px;">Click here to expand for the "virtualbox-import-and-modifyvm.ps1" !!!</span></summary>

```powershell
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
```

</details>
