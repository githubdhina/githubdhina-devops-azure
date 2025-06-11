param sqlServerName string = 'mySqlServer123'

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlServerName
  location: resourceGroup().location
  properties: {
    administratorLogin: 'sqladminuser'
    administratorLoginPassword: 'P@ssw0rd!'
  }
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
}
