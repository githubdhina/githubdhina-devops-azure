NICNAME=$(az vm nic show `
    --resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
    --vm-name nva `
    --nic $NICID `
    --query "{name:name}" --output tsv)
$NICNAME

$NICNAME=$(az vm nic show `
    --resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
    --vm-name nva `
    --nic $NICID `
    --query "{name:name}" --output tsv)
$NICNAME

az network nic update --name $NICNAME `
    --resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
    --ip-forwarding true

$NVAIP="$(az vm list-ip-addresses `
    --resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
    --name nva `
    --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" `
    --output tsv)"
$NVAIP


az vm create `
    --resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
    --name public `
    --vnet-name vnet `
    --subnet publicsubnet `
	--subnet-address-prefix 10.0.1.0/24 `
    --image Ubuntu2204 `
    --admin-username azureuser `
    --no-wait `
    --custom-data cloud-init.txt `
    --admin-password SuperSecretPassword1*
	
	
az vm create `
--resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
--name private `
--vnet-name vnet `
--subnet privatesubnet `
--subnet-address-prefix 10.0.2.0/24 `
--image Ubuntu2204 `
--admin-username azureuser `
--no-wait `
--custom-data cloud-init.txt `
--admin-password SuperSecretPassword1*

watch -d -n 5 "az vm list `
    --resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
    --show-details `
    --query '[*].{Name:name, ProvisioningState:provisioningState, PowerState:powerState}' `
    --output table"
	
$PUBLICIP="$(az vm list-ip-addresses `
--resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
--name public `
--query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" `
--output tsv)"

$PUBLICIP

$PRIVATEIP="$(az vm list-ip-addresses `
    --resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
    --name private `
    --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" `
    --output tsv)"

$PRIVATEIP