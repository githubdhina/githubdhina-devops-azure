param vnetName string = 'myVnet'
param subnetName string = 'mySubnet'
param subnetPrefix string = '10.0.1.0/24'

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: resourceId('Microsoft.Network/virtualNetworks', vnetName)
  name: subnetName
  properties: {
    addressPrefix: subnetPrefix
  }
}
