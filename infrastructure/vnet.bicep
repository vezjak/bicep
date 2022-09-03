@description('VNet name')
param vnetName string

@description('Address prefix')
param vnetAddressPrefix string

@description('Subnet prefix')
param subnetPrefix string

@description('Subnet name')
param subnetName string

@description('Location for all resources.')
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

output vnetID string = vnet.id
