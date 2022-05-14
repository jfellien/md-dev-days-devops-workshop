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
  tags:{
    deployment_cause:'deployment script'
  }
}

output functionAppName string = functionApp.name
