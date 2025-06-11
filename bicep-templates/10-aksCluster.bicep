param aksName string = 'myAKSCluster'

resource aks 'Microsoft.ContainerService/managedClusters@2022-03-01' = {
  name: aksName
  location: resourceGroup().location
  properties: {
    dnsPrefix: aksName
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: 'azureuser'
      ssh: {
        publicKeys: [
          {
            keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC...'
          }
        ]
      }
    }
    enableRBAC: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}
