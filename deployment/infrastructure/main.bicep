targetScope = 'subscription'

param location string = 'germanywestcentral'
param resourceGroupName string
@maxLength(12)
param applicationName string
@maxLength(3)
param attendeeId string

var internalResourceGroupName = '${resourceGroupName}-${attendeeId}'
var internalAppName = '${applicationName}${attendeeId}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: internalResourceGroupName
  location: location
}

module services 'services.bicep' = {
  name:'services-deployment'
  scope: resourceGroup
  params:{
    applicationName: internalAppName
    location: location
  }
}
