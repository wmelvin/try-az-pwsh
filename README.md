# try-az-pwsh

## Exploring Azure and PowerShell

This repository contains some scripts from my experimenting with using PowerShell to automate creating virtual machines in Azure. These scripts are not comprehensive or immediately reusable. They are here mainly for my future reference. If anyone else finds some useful bits, that's a bonus. ;-)

## Scripts

**az-create-linux-vm.ps1** - Creates a Linux VM for testing and configures SSH access.

**az-create-win-vm.ps1** - Creates a Windows VM for testing and opens the port for RDP access.

**az-funcs.ps1** - Contains several shared functions; dot-sourced by the other scripts.

**az-snips.ps1** - Contains various PowerShell commands. The commands are commented out. I run them in Visual Studio Code (or the PowerShell ISE) by selecting the text and pressing F8.


**There are setup steps needed before the scripts can be used:**

The [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) must be installed.

The PowerShell session must be signed in to Azure.

I store the credentials for the virtual machines in files kept in a separate local folder. The files are short PowerShell scripts that simply set variables to be referenced from the running script by [dot-sourcing](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2#script-scope-and-dot-sourcing) them.

Example *win-vm-creds-1.ps1*:
```
$VMUser = "badmin"
$VMPass = "badpassword123"
```

To create a Linux VM with SSH access, a SSH key is needed. I have a generated public key in `~/.ssh/id_rsa.pub` that is uploaded in the `az vm create` step.


## Reference

### Microsoft Docs

[az group create](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az_group_create)

[az network vnet create](https://docs.microsoft.com/en-us/cli/azure/network/vnet?view=azure-cli-latest#az_network_vnet_create)

[az network public-ip create](https://docs.microsoft.com/en-us/cli/azure/network/public-ip?view=azure-cli-latest#az_network_public_ip_create)

[az network nsg create](https://docs.microsoft.com/en-us/cli/azure/network/nsg?view=azure-cli-latest#az_network_nsg_create)

[az network nic create](https://docs.microsoft.com/en-us/cli/azure/network/nic?view=azure-cli-latest#az_network_nic_create)

[az vm open-port](https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az_vm_open_port)

[az vm create](https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az_vm_create)

[az vm list-ip-addresses](https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az_vm_list_ip_addresses)


### Other

Pro Git book - [Generating Your SSH Public Key](https://git-scm.com/book/en/v2/Git-on-the-Server-Generating-Your-SSH-Public-Key)

GitHub - [Generating a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

