param functionAppName string
param storageAccountConnectionString string
param appInsightsKey string
param runtime string

resource defaultFunctionAppAppsettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${functionAppName}/appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsKey
    AzureWebJobsStorage: storageAccountConnectionString
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: runtime
    WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG: 1
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: storageAccountConnectionString
    WEBSITE_CONTENTSHARE: toLower(functionAppName)
  }
}
