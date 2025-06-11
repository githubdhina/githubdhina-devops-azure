# Get public IP address of a VM

az vm list-ip-addresses --name MyVM --resource-group MyResourceGroup --query '[].virtualMachine.network.publicIpAddresses[].ipAddress' -o tsv
