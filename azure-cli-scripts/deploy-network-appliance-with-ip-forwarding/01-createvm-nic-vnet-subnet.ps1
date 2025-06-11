az vm create `
    --resource-group "learn-17308a74-2f13-42a8-97f9-f046ee417a76" `
    --name nva `
    --vnet-name vnet `
    --subnet dmzsubnet `
    --image Ubuntu2204 `
    --admin-username azureuser `
    --admin-password <password>