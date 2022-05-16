param applicationName string
param location string

module keyVault 'keyVault.bicep' = {
  name: 'keyVault-deployment'
  params:{
    name: applicationName
    location: location
  }
}

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
    keyVaultName: keyVault.outputs.keyVaultName
  }
  dependsOn:[
    keyVault
  ]
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

module functionAppAccessPolicy 'keyVaultAccessPolicy.bicep' = {
  name: 'function-app-keyvault-access-policy-deployment'
  params:{
    keyVaultName: keyVault.outputs.keyVaultName
    principalId: functionApp.outputs.principalId
    permission: 'low'
  }
  dependsOn:[
    functionApp
    keyVault
  ]
}

module apiFunctionAppSettingsModule 'functionAppSettings.bicep' = {
  name: 'function-appsettings-deployment'
  params: {
    appInsightsKey: appInsights.outputs.appInsightsKey
    functionAppName: functionApp.outputs.functionAppName
    storageAccountSecretUri: storageAccount.outputs.storageAccountSecretUri
    runtime: 'dotnet'
  }  
  dependsOn:[
    functionApp
    functionAppAccessPolicy
  ]
}
