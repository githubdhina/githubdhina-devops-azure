$SandBoxResourceGroupName = ""

#Create a new Traffic Manager profile
az network traffic-manager profile create `
    --resource-group "$SandBoxResourceGroupName" `
    --name TM-MusicStream-Priority `
    --routing-method Priority `
    --unique-dns-name TM-MusicStream-Priority-$RANDOM

#Run the following command to deploy a Resource Manager template
$Password = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | % {[char]$_})
    az deployment group create `
    --resource-group "$SandBoxResourceGroupName" `
    --template-uri  https://raw.githubusercontent.com/MicrosoftDocs/mslearn-distribute-load-with-traffic-manager/master/azuredeploy.json `
    --parameters password=$Password

#Run the following commands to add the public IP address resources of the virtual machines as endpoints to the Traffic Manager profile
$WestNicId=$(az network public-ip show `
    --resource-group "$SandBoxResourceGroupName" `
    --name westus2-vm-nic-pip `
    --query id `
    --output tsv)

az network traffic-manager endpoint create `
    --resource-group "$SandBoxResourceGroupName" `
    --profile-name TM-MusicStream-Priority `
    --name "Primary-WestUS" `
    --type azureEndpoints `
    --priority 1 `
    --target-resource-id $WestNicId

$WestEuropeNicId=$(az network public-ip show `
    --resource-group "$SandBoxResourceGroupName" `
    --name westeurope-vm-nic-pip `
    --query id `
    --output tsv)

az network traffic-manager endpoint create `
    --resource-group "$SandBoxResourceGroupName" `
    --profile-name TM-MusicStream-Priority `
    --name "Failover-WestEurope" `
    --type azureEndpoints `
    --priority 2 `
    --target-resource-id $WestEuropeNicId

#Take a quick look at the endpoints we configured
az network traffic-manager endpoint list `
    --resource-group "$SandBoxResourceGroupName" `
    --profile-name TM-MusicStream-Priority `
    --output table

#Test the app
#Retrieve the address for the West US 2 web app:
nslookup $(az network public-ip show `
            --resource-group "$SandBoxResourceGroupName" `
            --name westus2-vm-nic-pip `
            --query dnsSettings.fqdn `
            --output tsv)

#Retrieve the address for the West Europe web app:
nslookup $(az network public-ip show `
        --resource-group "$SandBoxResourceGroupName" `
        --name westeurope-vm-nic-pip `
        --query dnsSettings.fqdn `
        --output tsv)

# Retrieve the address for the Traffic Manager profile
nslookup $(az network traffic-manager profile show `
            --resource-group "$SandBoxResourceGroupName" `
            --name TM-MusicStream-Priority `
            --query dnsConfig.fqdn `
            --output tsv)
#The address for the Traffic Manager profile should match the IP address for the westus2-vm-nic-pip public IP assigned to the westus2-vm virtual machine.

#Run the following command to go to the Traffic Manager profile's fully qualified domain name (FQDN).
echo http://$(az network traffic-manager profile show `
    --resource-group "$SandBoxResourceGroupName" `
    --name TM-MusicStream-Priority `
    --query dnsConfig.fqdn `
    --output tsv)

#The code prints out the FQDN in Cloud Shell. Select the FQDN to open a new browser window or tab.
#Verify that the application is working and the location shown at the bottom of the page is West US 2:

#Run the following command to disable the primary endpoint:
az network traffic-manager endpoint update `
    --resource-group "$SandBoxResourceGroupName"  `
    --name "Primary-WestUS" `
    --profile-name TM-MusicStream-Priority `
    --type azureEndpoints `
    --endpoint-status Disabled

#Retrieve the address for the Traffic Manager profile:

nslookup $(az network traffic-manager profile show `
            --resource-group "$SandBoxResourceGroupName" `
            --name TM-MusicStream-Priority `
            --query dnsConfig.fqdn `
            --output tsv)

#The address for the Traffic Manager profile should now match the West Europe web app.

<#
Test the application again from your browser by refreshing the web page. 
Traffic Manager should automatically redirect the traffic to the West Europe endpoint. 
Depending on your browser, it might take a few minutes for the locally cached address to expire. 
Opening the site in a private window should bypass the cache, so you can see the change immediately.
#>
