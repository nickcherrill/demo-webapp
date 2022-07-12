@description('Shared parameters')
param location string

@description('Specific parameters')
param privateEndpointName string
param virtualNetworkName string
param connectsToType string
param linkedServiceID string
param subnetName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' existing = {
  name: subnetName
  parent: virtualNetwork
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: subnet.id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: linkedServiceID
          groupIds: [
            connectsToType
          ]
        }
      }
    ]
  }
}
