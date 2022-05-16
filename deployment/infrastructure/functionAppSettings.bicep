param functionAppName string
param storageAccountSecretUri string
param appInsightsKey string
param runtime string

var storageAccountKeyVaultSecret = '@Microsoft.KeyVault(SecretUri=${storageAccountSecretUri})'

resource defaultFunctionAppAppsettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${functionAppName}/appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsKey
    AzureWebJobsStorage: storageAccountKeyVaultSecret
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: runtime
    WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG: 1
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: storageAccountKeyVaultSecret
    WEBSITE_CONTENTSHARE: toLower(functionAppName)
  }
}
