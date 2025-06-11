param appServicePlanName string = 'myAppServicePlan'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: resourceGroup().location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  kind: 'app'
  properties: {
    reserved: false
  }
}
