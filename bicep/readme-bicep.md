
# Bicep

## Setup

Installed the 'Bicep' extension in Visual Studio Code.

Used the PowerShell terminal in VS Code to run the Azure CLI.

Had to upgrade the Azure CLI because the installed version did not include the bicep commands.

    az upgrade

Install Bicep:

    az bicep install

Check the version:

    az bicep version

    > CLI 0.6.18

To upgrade:

    az bicep upgrade

## Decompile an ARM Template

Used the script `az-create-linux-vm.ps1` (on [GitHub](https://github.com/wmelvin/try-az-pwsh/blob/c1904c8e58573e242863030fe300a2b6e0360ef6/az-create-linux-vm.ps1)) to create a Linux VM on Azure.

Exported the ARM template using the Azure Portal.

Extracted the ZIP containing the exported ARM template to a folder. Changed to that folder in the PowerShell console and ran the `decompile` command.

    az bicep decompile --file template.json

## Edit the Generated Bicep Template

Copied the `template.bicep` file created by the decompile process to `create-linux-vm-1.bicep`. Tried using the Bicep extension's auto-complete features to make new resource definitions with only the required items, but at this point that's mostly guesswork.

## Deploy to Azure

The script `deploy-linux-vm-1.ps1` creates the resource group and then creates the deployment group using `create-linux-vm-1.bicep`. 


### Getting the Public IP Address
**az vm [list-ip-addresses](https://docs.microsoft.com/en-US/cli/azure/vm?view=azure-cli-latest#az-vm-list-ip-addresses)**

Given a VM named **tmp1-linux-1**, this command sets `$ip` to the public IP address:

```pwsh
$ip = az vm list-ip-addresses --name "tmp1-linux-1" --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress | [0][0]"
```

The **--query** parameter provides a way to select specific items from the JSON result using a [JMESPath](https://docs.microsoft.com/en-us/cli/azure/query-azure-cli?tabs=concepts%2Cbash) query string. The above query assumes there is only one public IP address as it selects the first element from the nested array using `[0][0]`.

The `$ip` variable can be used to connect via SSH (assumes `$VMUser` contains the user name):

```pwsh
ssh -l $VMUser $ip
```

See also:
- [JMESPath - Documentation](https://jmespath.readthedocs.io/en/latest/#)
- [JMESPath - Working with Nested Data](https://jmespath.org/examples.html#working-with-nested-data)


## More Docs

[Bicep documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)

[Decompiling ARM template JSON to Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/decompile)


[resource-providers-and-types](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types)

[azure-services-resource-providers](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers)

[az-deployment-group-create](https://docs.microsoft.com/en-us/cli/azure/deployment/group?view=azure-cli-latest#az-deployment-group-create)

[quickstart-create-bicep-use-visual-studio-code](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-visual-studio-code?tabs=CLI)

