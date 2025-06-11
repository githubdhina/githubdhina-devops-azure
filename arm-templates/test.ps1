$folder = "arm-templates"

if (-not (Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder | Out-Null
    Write-Host "Created folder: $folder"
} else {
    Write-Host "Folder already exists: $folder"
}

# README.md content
$readme = @'
# ARM Templates

Sample ARM templates demonstrating deployment of common Azure resources.

Use these templates as starting points for Infrastructure as Code with ARM JSON.
'@

$readmePath = Join-Path $folder "README.md"
if (-not (Test-Path $readmePath)) {
    Set-Content -Path $readmePath -Value $readme -Encoding utf8
    Write-Host "Created README.md"
} else {
    Write-Host "README.md already exists"
}

# Define 10 ARM templates as raw single-quoted here-strings
$templates = @{

"01-storage-account.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "type": "string",
      "defaultValue": "mystorageacct123",
      "metadata": { "description": "Storage Account name" }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2021-04-01",
      "name": "[parameters('storageAccountName')]",
      "location": "[resourceGroup().location]",
      "sku": { "name": "Standard_LRS" },
      "kind": "StorageV2",
      "properties": {}
    }
  ]
}
'@

"02-virtual-network.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vnetName": {
      "type": "string",
      "defaultValue": "myVnet",
      "metadata": { "description": "Virtual Network Name" }
    },
    "addressPrefix": {
      "type": "string",
      "defaultValue": "10.0.0.0/16",
      "metadata": { "description": "Address prefix for VNet" }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2020-11-01",
      "name": "[parameters('vnetName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": ["[parameters('addressPrefix')]"] 
        }
      }
    }
  ]
}
'@

"03-network-security-group.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "nsgName": {
      "type": "string",
      "defaultValue": "myNSG",
      "metadata": { "description": "Network Security Group Name" }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2021-02-01",
      "name": "[parameters('nsgName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "securityRules": [
          {
            "name": "AllowSSH",
            "properties": {
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "destinationPortRange": "22",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*",
              "access": "Allow",
              "priority": 1000,
              "direction": "Inbound"
            }
          }
        ]
      }
    }
  ]
}
'@

"04-virtual-machine.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string",
      "defaultValue": "myVM",
      "metadata": { "description": "Virtual Machine Name" }
    },
    "adminUsername": {
      "type": "string",
      "defaultValue": "azureuser",
      "metadata": { "description": "Admin Username" }
    },
    "adminPassword": {
      "type": "securestring",
      "metadata": { "description": "Admin Password" }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2021-07-01",
      "name": "[parameters('vmName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "hardwareProfile": {
          "vmSize": "Standard_DS1_v2"
        },
        "osProfile": {
          "computerName": "[parameters('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "Canonical",
            "offer": "UbuntuServer",
            "sku": "18.04-LTS",
            "version": "latest"
          },
          "osDisk": {
            "createOption": "FromImage"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', concat(parameters('vmName'),'-nic'))]"
            }
          ]
        }
      }
    },
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2021-02-01",
      "name": "[concat(parameters('vmName'),'-nic')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', 'myVnet', 'default')]"
              },
              "privateIPAllocationMethod": "Dynamic"
            }
          }
        ]
      }
    }
  ]
}
'@

"05-app-service.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appServiceName": {
      "type": "string",
      "defaultValue": "myAppService",
      "metadata": { "description": "App Service Name" }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2021-02-01",
      "name": "[parameters('appServiceName')]",
      "location": "[resourceGroup().location]",
      "kind": "app",
      "properties": {
        "serverFarmId": "[resourceId('Microsoft.Web/serverfarms', 'myAppServicePlan')]"
      }
    },
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2021-02-01",
      "name": "myAppServicePlan",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "F1",
        "tier": "Free"
      },
      "properties": {}
    }
  ]
}
'@

"06-storage-blob.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "type": "string",
      "defaultValue": "mystorageacct123",
      "metadata": { "description": "Storage Account name" }
    },
    "containerName": {
      "type": "string",
      "defaultValue": "mycontainer",
      "metadata": { "description": "Blob container name" }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
      "apiVersion": "2021-04-01",
      "name": "[concat(parameters('storageAccountName'), '/default/', parameters('containerName'))]",
      "dependsOn": [
        "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
      ],
      "properties": {
        "publicAccess": "None"
      }
    }
  ]
}
'@

"07-sql-server.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlServerName": {
      "type": "string",
      "defaultValue": "mySqlServer123",
      "metadata": { "description": "SQL Server Name" }
    },
    "administratorLogin": {
      "type": "string",
      "defaultValue": "sqladmin",
      "metadata": { "description": "Administrator login" }
    },
    "administratorLoginPassword": {
      "type": "securestring",
      "metadata": { "description": "Administrator password" }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Sql/servers",
      "apiVersion": "2021-02-01-preview",
      "name": "[parameters('sqlServerName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "administratorLogin": "[parameters('administratorLogin')]",
        "administratorLoginPassword": "[parameters('administratorLoginPassword')]",
        "version": "12.0"
      }
    }
  ]
}
'@

"08-sql-db.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "sqlServerName": {
      "type": "string",
      "defaultValue": "mySqlServer123",
      "metadata": { "description": "SQL Server Name" }
    },
    "databaseName": {
      "type": "string",
      "defaultValue": "myDatabase",
      "metadata": { "description": "Database Name" }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Sql/servers/databases",
      "apiVersion": "2021-02-01-preview",
      "name": "[concat(parameters('sqlServerName'), '/', parameters('databaseName'))]",
      "location": "[resourceGroup().location]",
      "properties": {
        "collation": "SQL_Latin1_General_CP1_CI_AS",
        "maxSizeBytes": "2147483648",
        "sampleName": "AdventureWorksLT"
      },
      "dependsOn": [
        "[resourceId('Microsoft.Sql/servers', parameters('sqlServerName'))]"
      ]
    }
  ]
}
'@

"09-app-insights.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appInsightsName": {
      "type": "string",
      "defaultValue": "myAppInsights",
      "metadata": { "description": "Application Insights Name" }
    }
  },
  "resources": [
    {
      "type": "microsoft.insights/components",
      "apiVersion": "2015-05-01",
      "name": "[parameters('appInsightsName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "Application_Type": "web"
      }
    }
  ]
}
'@

"10-key-vault.json" = @'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "keyVaultName": {
      "type": "string",
      "defaultValue": "myKeyVault123",
      "metadata": { "description": "Key Vault Name" }
    }
  },
  "resources": [
    {
      "type": "Microsoft.KeyVault/vaults",
      "apiVersion": "2021-06-01-preview",
      "name": "[parameters('keyVaultName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "sku": {
          "family": "A",
          "name": "standard"
        },
        "tenantId": "[subscription().tenantId]",
        "accessPolicies": []
      }
    }
  ]
}
'@

}

# Write each ARM template file
foreach ($templateName in $templates.Keys) {
    $filePath = Join-Path $folder $templateName
    if (-not (Test-Path $filePath)) {
        Set-Content -Path $filePath -Value $templates[$templateName] -Encoding utf8
        Write-Host "Created $templateName"
    } else {
        Write-Host "$templateName already exists"
    }
}

Write-Host "`n✅ Created arm-templates folder with 10 sample ARM JSON templates."
