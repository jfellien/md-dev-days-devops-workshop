param name string
param location string
param databaseName string
param containerName string
param containerPartitionKeyName string
param keyVaultName string

var locations = [
  {
    locationName: location
    failoverPriority: 0
    isZoneRedundant: false
  }
]

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2021-01-15' = {
  name: name
  kind: 'GlobalDocumentDB'
  location: location
  properties: {
    locations: locations
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-01-15' = {
  parent: databaseAccount
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-01-15' = {
  parent: database
  name: containerName
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          '/${containerPartitionKeyName}'
        ]
        kind: 'Hash'
      }
    }
    options: {
      autoscaleSettings: {
        maxThroughput: 4000
      }
    }
  }
}

resource keyVaultSettings 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyVaultName
  resource storageConnectionString 'secrets' = {
    name: '${name}-Cosmos-ConnectionString'
      properties: {
        value: databaseAccount.listConnectionStrings().connectionStrings[0].connectionString
      }
  }
}

output secretConnectionStringUri string = keyVaultSettings::storageConnectionString.properties.secretUri
