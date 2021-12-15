
# ----------------------------------------------------------------------

function RGExists([string]$rgName)
{
    $t = az group list | ConvertFrom-Json | Select-Object Name
    if ($null -eq $t) {
        return $false
    }
    else {
        return $t.Name.Contains($rgName)
    }
}

#  https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az_group_list


# ----------------------------------------------------------------------

function VNetExists([string]$rgName, [string]$vnetName)
{
    $t = $null
    $t = az network vnet list | ConvertFrom-Json | Select-Object Name
    if ($null -eq $t) {
        return $false
    }
    else {
        Write-Host -ForegroundColor Cyan $vnetName
        Write-Host -ForegroundColor Cyan $t
        return $t.Name.ToString().Contains($vnetName)
    }
}

#  https://docs.microsoft.com/en-us/cli/azure/network/vnet?view=azure-cli-latest#az_network_vnet_list


# ----------------------------------------------------------------------
