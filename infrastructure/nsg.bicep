@description('Location for all resources.')
param location string

@description('The name of NSG.')
param networkSecurityGroupName string

@description('List of NSG rules.')
param rules array

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: rules
  }
}

output nsgID string = nsg.id
