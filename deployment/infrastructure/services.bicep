param applicationName string
param location string

module appInsights 'appInsights.bicep' = {
  name: 'appInsights-deployment'
  params:{
    name: applicationName
    location: location
  }
}

module storageAccount 'storageAccount.bicep' = {
  name:'storage-account-deployment'
  params:{
    storageAccountName: applicationName
    location: location
  }
}

module appServicePlan 'appServicePlan.bicep' = {
  name: 'app-service-plan-deployment'
  params:{
    name: applicationName
    location: location
  }
}

module functionApp 'functionApp.bicep' = {
  name: 'function-app-deployment'
  params:{
    name: applicationName
    location: location
    appServicePlanId: appServicePlan.outputs.id
  }
  dependsOn:[
    appInsights
    storageAccount
    appServicePlan
  ]
}

module apiFunctionAppSettingsModule 'functionAppSettings.bicep' = {
  name: 'function-appsettings-deployment'
  params: {
    appInsightsKey: appInsights.outputs.appInsightsKey
    functionAppName: functionApp.outputs.functionAppName
    storageAccountConnectionString: storageAccount.outputs.storageAccountConnectionString
    runtime: 'dotnet'
  }  
  dependsOn:[
    functionApp
  ]
}
