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
