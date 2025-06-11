resource aks 'Microsoft.ContainerService/managedClusters@2022-09-01' = {
  name: 'myAksCluster'
  location: resourceGroup().location
  properties: {
    dnsPrefix: 'myakscluster'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    identity: {
      type: 'SystemAssigned'
    }
  }
}