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
