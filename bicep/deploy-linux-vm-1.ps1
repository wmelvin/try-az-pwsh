
$base_name = "tmp1"
$rg_name = "${base_name}-rg"
$location = "eastus"

# az login

az group create --name $rg_name --location $location

$pub_key = Get-Content  ~/.ssh/id_rsa.pub

# Get credentials from file in local encrypted folder.
$credsFile = "$env:UserProfile\KeepLocal\linux-vm-creds-1.ps1"
. $credsFile
if (0 -eq $VMUser.Length) {
    Write-Host "Failed to get User Name from '$credsFile'."
    Exit 1
}


az deployment group create --resource-group $rg_name --template-file .\create-linux-vm-1.bicep --parameters base_name=$base_name admin_user_name=$VMUser ssh_pub_key=$pub_key --what-if


# $ip = az vm list-ip-addresses --name "tmp1-linux-1" --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress | [0][0]"
# ssh -l $VMUser $ip
