param name string
param appServicePlanId string
param location string

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: name
  identity:{
    type:'SystemAssigned'    
  }
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlanId
  }
}

output functionAppName string = functionApp.name
output principalId string = functionApp.identity.principalId
