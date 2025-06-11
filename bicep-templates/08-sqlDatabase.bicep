param sqlServerName string = 'mySqlServer123'
param databaseName string = 'myDatabase'

resource database 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: resourceId('Microsoft.Sql/servers', sqlServerName)
  name: databaseName
  location: resourceGroup().location
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
  properties: {}
}
