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
}

var cosmosDbName = '${applicationName}-db'
var cosmosDbContainerName = 'myData'

module cosmosDB 'cosmosDB.bicep' = {
  name: 'cosmosdb-deployment'
  params:{
    name: applicationName
    location: location
    keyVaultName: keyVault.outputs.keyVaultName
    databaseName: cosmosDbName
    containerName: cosmosDbContainerName
    containerPartitionKeyName: '/myPartitionKey'
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
  ]
}

module apiFunctionAppSettingsModule 'functionAppSettings.bicep' = {
  name: 'function-appsettings-deployment'
  params: {
    appInsightsKey: appInsights.outputs.appInsightsKey
    functionAppName: functionApp.outputs.functionAppName
    storageAccountSecretUri: storageAccount.outputs.storageAccountSecretUri
    cosmosDbSecretUri: cosmosDB.outputs.secretConnectionStringUri
    cosmosDbName: cosmosDbName
    cosmosDbContainerName: cosmosDbContainerName
    runtime: 'dotnet'
  }  
  dependsOn:[
    functionApp
    functionAppAccessPolicy
    cosmosDB
  ]
}
