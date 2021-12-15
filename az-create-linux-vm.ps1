# ----------------------------------------------------------------------
# Create a Linux virtual machine.

# Source some shared functions.
. .\az-funcs.ps1

# Get credentials from file in local encrypted folder.
$credsFile = "$env:UserProfile\KeepLocal\linux-vm-creds-1.ps1"
. $credsFile
if (0 -eq $VMUser.Length) {
    Write-Host "Failed to get User Name from '$credsFile'."
    Exit 1
}


$logFileName = ".\zlog-az-create-linux-vm.txt"

function zlog($text)
{
    Write-Host $text
    Out-File -FilePath $logFileName -Append -Encoding ascii `
        -InputObject $text
}

function zlogt($text) 
{
    zlog ("[{0}] {1}" -f (Get-Date).ToString('yyyy-MM-dd HH:mm:ss'), $text)
}


# zlog "This is a test."
# zlogt "And another"


function new-linux-vm($rgbase, $image, $location, $start_step)
{
    $result = $null
    try
    {
        zlogt 'BEGIN'
        zlog "`$rgbase: $rgbase"
        zlog "`$image: $image"
        zlog "`$location: $location"
        zlog "`$start_step: $start_step"
        
        $rgname = "$rgbase-rg"
        zlog "`$rgname: $rgname"

        $vnetname = "$rgbase-vnet-1"
        zlog "`$vnetname: $vnetname"

        $subnetname = "$rgbase-subnet-1"
        zlog "`$subnetname: $subnetname"

        $nicname = "$rgbase-linux-1-nic-1"
        zlog "`$nicname: $nicname"

        $pipname = "$rgbase-linux-1-pip-1"
        zlog "`$pipname: $pipname"

        $nsgname = "$rgbase-linux-nsg-1"
        zlog "`$nsgname: $nsgname"

        $vmname = "$rgbase-linux-1"
        zlog "`$vmname: $vmname"

        if ($start_step -le 1) {
            $result = $null
            $step = "group create ($rgname)"
            zlogt "STEP: $step"
            if (RGExists $rgname) {
                zlog "Resource group exists."
            }
            else {
                $result = az group create `
                    --name $rgname `
                    --location $location
            }    
        }
        az group list -o table

        if ($start_step -le 2) {
            $result = $null
            $step = "network vnet create ($vnetname)"
            zlogt "STEP: $step"
            if (VNetExists $rgname $vnetname) {
                zlog "VNet exists."
            }
            else {
                $result = az network vnet create `
                    --resource-group $rgname `
                    --name $vnetname `
                    --address-prefix "10.1.0.0/16" `
                    --subnet-name $subnetname `
                    --subnet-prefix "10.1.1.0/24"
            }    
        }
        az network vnet list -o table

        if ($start_step -le 3) {
            $result = $null
            $step = "network public-ip create ($pipname)"
            zlogt "STEP: $step"
            $result = az network public-ip create `
                --resource-group $rgname `
                --name $pipname    
        }
        az network public-ip list -o table

        if ($start_step -le 4) {
            $result = $null
            $step = "network nsg create ($nsgname)"
            zlogt "STEP: $step"
            $result = az network nsg create `
                --resource-group $rgname `
                --name $nsgname    
        }
        az network nsg list -o table

        if ($start_step -le 5) {
            $result = $null
            $step = "network nic create ($nicname)"
            zlogt "STEP: $step"
            $result = az network nic create `
                --resource-group $rgname `
                --name $nicname `
                --vnet-name $vnetname `
                --subnet $subnetname `
                --network-security-group $nsgname `
                --public-ip-address $pipname    
        }
        az network nic list -o table

        if ($start_step -le 6) {
            $result = $null
            $step = "vm create ($vmname)"
            zlogt "STEP: $step"
            $result = az vm create `
                --resource-group $rgname `
                --location $location `
                --name $vmname `
                --nics $nicname `
                --image $image `
                --admin-username $VMUser `
                --authentication-type "ssh" `
                --ssh-key-value ~/.ssh/id_rsa.pub    
        }
        az vm list -o table

        if ($start_step -le 7) {
            $result = $null
            $step = 'vm open-port'
            zlogt "STEP: $step"
            $result = az vm open-port `
                --resource-group $rgname `
                --name $vmname `
                --port "22"    
        }        

        zlogt 'END'
    }
    catch
    {
        zlogt "ERROR"
        zlog "Step: $step"
        zlog $_.ErrorID
        zlog $_.Exception.Message
        if ($null -ne $result) {
            $err_file_name = "zError-new-linux-vm-last-result.txt"
            Out-File -FilePath $err_file_name -Encoding ascii -InputObject $result
            zlog "See also: $err_file_name"
        }
        break
    }
}


# ----------------------------------------------------------------------

new-linux-vm "tmp1" "UbuntuLTS" "eastus" 0

#  RedHat Linux image: "rhel"


# -- Get IP address.
# az vm list-ip-addresses --name "tmp1-linux-1" -o table


# ----------------------------------------------------------------------
