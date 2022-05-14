# MD Dev Days Workshop

## Ziel:
Vermittlung des DevOps Prinzips anhand einer Serverless Application 


## Agenda:

### Erste Iteration
---

1) Entwicklung einer Azure Function (Http Triggered)

1) Bereitstellung der Infrastruktur für die entwickelte Azure Function

    * Login to Azure Subscription
        ```
        az login
        ```
    * Default Azure Subscription
        ```
        az account set --subscription <id>
        ```
    * Infrastructure für die Function erstellen (Bicep)

        Bicep installieren
        ```
        az bicep install
        ```

        Eine Function benötigt ein *Application Insights Service*, einen eigenen *Storage Account*, ein *AppService Plan* und einen *AppService*
    
    * Infrastruktur ausrollen
        ```
        az deployment sub create `
            --template-file main.bicep `
            --location germanywestcentral `
            --parameters `
                resourceGroupName=md-dev-days `
                applicationName=orderfood `
                attendeeId=<Teilnehmerkennung max 3 Zeichen>
        ```

1) Deployment der Azure Function (Yaml)
---

### Zweite Iteration
---

1) Hinzufügen eines KeyVault
    * Berechtigung der Function zum Lesen im KeyVault hinzufügen
1) Connectionstring des StorageAccount in den KeyVault legen
1) Hinzufügen einer CosmosDB
    * Hinzufügen als Infrastrukturresource
    * Einfügen des ConnectionStrings zum KeyVault
1) CosmosDB Binding zur Function hinzufügen
    * Anlegen eines Settings
    * Anlegen eines Parameters