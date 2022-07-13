// ================ //
// Scope            //
// ================ //

targetScope = 'subscription' // Select which subscription via Service Principle on deployment yml

// ================ //
// Parameters       //
// ================ //

@description('Shared parameters')
param location string
param tags object

@description('Resource Groups multi-deploy')
param frontDoorResourceGroup string
param webTierResourceGroup string
param dataTierResourceGroup string

@description('Web Tier')
param webSubnets array
param webVnetName string
param webVnetAddressPrefixes array

@description('Data Tier')
param dataSubnets array
param dataVnetName string
param dataVnetAddressPrefixes array

@description('Private Endpoint parameters')
param sqlPrivateEndpoint object
param webPrivateEndpoint object

// =========== //
// Deployments //
// =========== //

resource deployResourceGroupA 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: frontDoorResourceGroup // Front Door and WAF policy
  location: location
}

resource deployResourceGroupB 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: webTierResourceGroup // Web Tier
  location: location
}

resource deployResourceGroupC 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: dataTierResourceGroup // Data Tier
  location: location
}

module deployWebVirtualNetwork '../modules/virtualnetwork.bicep' = {
  name: 'deployWebVnet'
  scope: resourceGroup(deployResourceGroupB.id)
  params: {
    location: location
    vnetName: webVnetName
    subnets: webSubnets
    addressPrefixes: webVnetAddressPrefixes
    tags: tags
  }
}

module deployDataVirtualNetwork '../modules/virtualnetwork.bicep' = {
  name: 'deployDataVnet'
  scope: resourceGroup(deployResourceGroupC.id)
  params: {
    location: location
    vnetName: dataVnetName
    subnets: dataSubnets
    addressPrefixes: dataVnetAddressPrefixes
    tags: tags
  }
}

module deployWebApp '../modules/appservice.bicep' = {
  name: 'deployWebApp'
  scope: resourceGroup(deployResourceGroupB.id)
  params: {
    // location: location
    // intentionally incomplete
  }
}
output WebAppServiceId string = deployWebApp.outputs.WebAppServiceId

module deployWebAppServicePrivateEndpoint '../modules/privateendpoint.bicep' = {
  name: 'deployWebAppServicePrivateEndpoint'
  scope: resourceGroup(deployResourceGroupB.id)
  params: {
    location: location
    privateEndpointName: webPrivateEndpoint.Name
    virtualNetworkName: webVnetName
    connectsToType: webPrivateEndpoint.connectsToType
    linkedServiceID: deployWebApp.outputs.WebAppServiceId
    subnetName: webPrivateEndpoint.subnetName
  }
}

module deploySQLServer '../modules/sql.bicep' = {
  name: 'deploySQLServer'
  scope: resourceGroup(deployResourceGroupC.id)
  params: {
    // location: location
    // intentionally incomplete
  }
}
output SQLServiceId string = deploySQLServer.outputs.SQLServiceId

module deploySQLPrivateEndpoint '../modules/privateendpoint.bicep' = {
  name: 'deploySQLPrivateEndpoint'
  scope: resourceGroup(deployResourceGroupC.id)
  params: {
    location: location
    privateEndpointName: sqlPrivateEndpoint.Name
    virtualNetworkName: dataVnetName
    connectsToType: sqlPrivateEndpoint.connectsToType
    linkedServiceID: deploySQLServer.outputs.SQLServiceId
    subnetName: sqlPrivateEndpoint.subnetName
  }
}
