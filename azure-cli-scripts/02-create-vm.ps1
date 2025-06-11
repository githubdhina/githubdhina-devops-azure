# Create an Ubuntu VM

az vm create 
  --resource-group MyResourceGroup 
  --name MyVM 
  --image Ubuntu2204 
  --admin-username azureuser 
  --generate-ssh-keys
