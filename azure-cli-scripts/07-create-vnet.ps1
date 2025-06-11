# Create a virtual network and subnet

az network vnet create 
  --resource-group MyResourceGroup 
  --name MyVnet 
  --address-prefix 10.0.0.0/16 
  --subnet-name MySubnet 
  --subnet-prefix 10.0.0.0/24
