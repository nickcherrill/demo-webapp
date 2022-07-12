@description('Shared parameters')
param location string
param virtualNetwork object

@description('Private Endpoint parameters')
param privateEndpoint object

resource deployVirtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetwork.Name
  location: location
  properties: {

  }
}

module deploySQLPrivateEndpoint '../modules/privateendpoint.bicep' = {
  name: 'deploySQLPrivateEndpoint'
  scope: resourceGroup(virtualNetwork.resourceGroup)
  params: {
    location: location
    privateEndpointName: privateEndpoint.Name
    virtualNetworkName: privateEndpoint.VirtualNetworkName
    connectsToType: privateEndpoint.connectsToType
    linkedServiceID: privateEndpoint.linkedServiceID
    subnetName: privateEndpoint.subnetName
  }
}
