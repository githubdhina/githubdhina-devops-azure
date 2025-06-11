param acrName string = 'myContainerRegistry123'

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01' = {
  name: acrName
  location: resourceGroup().location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}
