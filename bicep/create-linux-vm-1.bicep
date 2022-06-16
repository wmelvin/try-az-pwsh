
param base_name string
param admin_user_name string
param ssh_pub_key string
param rg_location string = resourceGroup().location

var vnet_name = '${base_name}-vnet-1'
var subnet_name = '${base_name}-subnet-1'
var nic_name = '${base_name}-linux-1-nic-1'
var pip_name = '${base_name}-linux-1-pip-1'
var nsg_name = '${base_name}-linux-nsg-1'
var vm_name = '${base_name}-linux-1'
var ssh_key_path = '/home/${admin_user_name}/.ssh/authorized_keys'


resource networkSecurityGroups_resource 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: nsg_name
  location: rg_location
  properties: {
    securityRules: [
      {
        name: 'open-port-22'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 900
          direction: 'Inbound'
        }
      }
    ]
  }
}


resource publicIPAddress_resource 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: pip_name
  location: rg_location
}


resource virtualNetworks_resource 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnet_name
  location: rg_location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet_name
        properties: {
          addressPrefix: '10.1.1.0/24'
        }
      }
    ]

  }
}


resource virtualMachines_resource 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vm_name
  location: rg_location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS11_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        createOption: 'FromImage'
        deleteOption: 'Detach'
        diskSizeGB: 30
      }
    }
    osProfile: {
      computerName: vm_name
      adminUsername: admin_user_name
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: ssh_key_path
              keyData: ssh_pub_key
            }
          ]
        }
        provisionVMAgent: true
      }
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_nic_name_resource.id
          properties: {
            primary: true
          }
        }
      ]
    }
    
  }
}


resource networkSecurityGroups_OpenPort22_Rule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-08-01' = {
  parent: networkSecurityGroups_resource
  name: 'open-port-22'
  properties: {
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 900
    direction: 'Inbound'
  }
}


resource virtualNetworks_subnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
  parent: virtualNetworks_resource
  name: subnet_name
  properties: {
    addressPrefix: '10.1.1.0/24'
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}


resource networkInterfaces_nic_name_resource 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: nic_name
  location: rg_location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress_resource.id
          }
          subnet: {
            id: virtualNetworks_subnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: networkSecurityGroups_resource.id
    }
  }
}
