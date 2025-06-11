param webAppName string = 'myWebApp'
param appServicePlanName string = 'myAppServicePlan'

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webAppName
  location: resourceGroup().location
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
  }
}
