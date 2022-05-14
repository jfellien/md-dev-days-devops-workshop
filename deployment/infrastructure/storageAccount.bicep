@maxLength(24)
param storageAccountName string
param location string
param keyVaultName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku:{
    name: 'Standard_LRS'
  }
  tags:{
    deployment_cause:'deployment script'
  }
}

resource keyVaultSettings 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
  resource storageConnectionString 'secrets' = {
    name: '${storageAccountName}-ConnectionString'
      properties: {
        value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(resourceId(resourceGroup().name, 'Microsoft.Storage/storageAccounts', storageAccountName), '2019-04-01').keys[0].value};EndpointSuffix=core.windows.net'
      }
  }
}

output storageAccountSecretUri string = keyVaultSettings::storageConnectionString.properties.secretUri
