param name string
param location string = resourceGroup().location

resource appIns 'Microsoft.Insights/components@2020-02-02-preview' = {
  name:name
  kind:'web'
  location:location
  properties:{
    Application_Type:'web'
    Request_Source:'rest'
    Flow_Type:'Bluefield'
  }
  tags:{
    deployment_cause:'deployment script'
  }
}

output appInsightsKey string = reference(appIns.id, '2014-04-01').InstrumentationKey
