targetScope = 'subscription'

param location string = deployment().location

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'simple-rg'
  location: location
}

module vnet '../../infrastructure/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    vnetName: 'simple-vnet'
    vnetAddressPrefix: '10.0.0.0/16'
    subnetName: 'simple-snet'
    subnetPrefix: '10.0.0.0/24'
    location: rg.location
  }
  scope: rg
}

module nsg '../../infrastructure/nsg.bicep' = {
  name: 'nsgDeployment'
  params: {
    location: rg.location
    networkSecurityGroupName: 'simplensg'
    rules:[
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
  scope: rg
}

module nic '../../infrastructure/nic.bicep' = {
  name: 'nicDeployment'
  params: {
    location: rg.location
    networkInterfaceName: 'vmnic'
    snetID: vnet.outputs.vnetID
    nsgID: nsg.outputs.nsgID
  }
  scope: rg
}

module vm_linux '../../infrastructure/vm-linux.bicep' = {
  name: 'vmLinDeployment'
  params: {
    vmName: 'simpleLinux-vm'
    adminUsername: 'ladmin'
    authenticationType: 'password'
    adminPasswordOrKey: 'SuperSecurePassword1!'
    ubuntuOSVersion: '18.04-LTS'
    location: rg.location
    vmSize: 'Standard_B2s'
    osDiskType: 'Standard_LRS'
    nicID: nic.outputs.nicID
  }
  scope: rg
}
