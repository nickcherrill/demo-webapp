@description('Shared parameters')
param location string = '${resourceGroup().location}'
param tags object = {} // optional resource tags

@description('Specific parameters')
param vnetName string
param subnets array
param addressPrefixes array

resource deployRouteTable 'Microsoft.Network/routeTables@2022-01-01' = [for (subnet, i) in subnets: if (subnet.attachRotueTable) {
  name: '${subnet.name}-routeTable'
  location: location
  tags: tags
  properties: {
    routes: [for (route, j) in subnet.routeProperties: {
      name: route.name
      properties: {
        addressPrefix: route.addressPrefix
        nextHopIpAddress: route.nextHopIpAddress
        nextHopType: route.nextHopType
      }
    }]
  }
}]

resource deployNSG 'Microsoft.Network/networkSecurityGroups@2022-01-01' = [for (subnet, i) in subnets: if (subnet.attachNSG) {
  name: '${subnet.name}-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: [for (rule, j) in subnet.nsgProperties: {
      name: rule.name
      properties: {
        priority: rule.priority
        access: rule.access
        direction: rule.direction
        sourceAddressPrefix: rule.sourceAddressPrefix
        sourcePortRange: rule.sourcePortRange
        destinationAddressPrefix: rule.destinationAddressPrefix
        destinationPortRange: rule.destinationPortRange
        protocol: rule.protocol
      }
    }]
  }
}]

resource deployVnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [for (subnet, i) in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        delegations: (subnet.addDelegation) ? [
          {
            name: subnet.delegationName
            properties: {
              serviceName: subnet.delegationServiceName
            }
          }
        ] : any(null)
        serviceEndpoints: (subnet.addServiceEndpoint) ? subnet.serviceEndpointProperties : any(null)
        routeTable: (subnet.attachRouteTable) ? {
          id: deployRouteTable[i].id
        } : any(null)
        networkSecurityGroup: (subnet.attachNSG) ? {
          id: deployNSG[i].id
        } : any(null)
      }
    }]
  }
}
