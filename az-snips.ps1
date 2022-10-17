# ----------------------------------------------------------------------
#  az-snips.ps1
#
#  Snippets of code to select and run using F8.
# ----------------------------------------------------------------------

# https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest


# ----------------------------------------------------------------------
#  General:

# -- Show current context (account, subscription).
# Get-AzContext

# -- If there are problems with login, disconnect and reconnect.
# Disconnect-AzAccount
# Connect-AzAccount -Subscription 'SUBSCRIPTION_NAME_HERE'

# az login


# -- List VMs that exist in current context.
# az vm list --show-details -o table


# ----------------------------------------------------------------------
#  Linux VM created by az-create-linux-vm.ps1.

# az vm list-ip-addresses --name "tmp1-linux-1" -o table

# ssh -l vladmin x.x.x.x

# az vm stop -g 'tmp1-rg' -n 'tmp1-linux-1'

# az vm deallocate -g 'tmp1-rg' -n 'tmp1-linux-1'



# ----------------------------------------------------------------------
#  Windows VM created by az-create-win-vm.ps1.

# az vm list-ip-addresses -n "tmp1-win-1" -o table

# az vm stop -g 'tmp1-rg' -n 'tmp1-win-1'

# az vm deallocate -g 'tmp1-rg' -n 'tmp1-win-1'


# ----------------------------------------------------------------------

# -- Delete the whole resource group.
# az group delete -n 'tmp1-rg'



# ----------------------------------------------------------------------
#  Misc:

# Find-Module Az

# Get-Module Az -ListAvailable

# Update-Module Az


# ----------------------------------------------------------------------
# List available virtual machine images.

# az vm image list

# az vm image list --all --location eastus --publisher Microsoft -o table


# -- Write the list of images published by Microsoft, and available in eastus, to a CSV file on the Desktop.
# az vm image list --all --location eastus --publisher Microsoft | ConvertFrom-Json | Export-Csv -Path ([IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "azure-image-list.csv"))


# -- See the details for a specific image by URN.

# az vm image show --location eastus --urn MicrosoftWindowsDesktop:windows-11:win11-21h2-pron:22000.978.220910

# az vm image show --location eastus --urn MicrosoftVisualStudio:visualstudioplustools:vs-2022-pro-general-win11-m365-gen2:2022.09.30

# az vm image show --location eastus --urn MicrosoftVisualStudio:visualstudio2022:vs-2022-comm-latest-ws2022:2022.09.21

# az vm image show --location eastus --urn MicrosoftVisualStudio:visualstudio2022:vs-2022-comm-latest-win11-n-gen2:2022.09.21


# ----------------------------------------------------------------------
