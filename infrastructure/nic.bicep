@description('Location for all resources.')
param location string

@description('The name of NIC.')
param networkInterfaceName string

@description('Subnet ID.')
param snetID string

@description('Network Security Group ID.')
param nsgID string

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: snetID
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgID
    }
  }
}

output nicID string = nic.id
