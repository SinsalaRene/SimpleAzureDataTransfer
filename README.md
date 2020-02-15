Structure for PowershellScriptConfig.json:
{
"clientId": "",
"clientSecret": "",
"tenantId": "",
"subscriptionId": "",
"resourceGroupName": "automationAcc-rg",
"automationAccName": "DevOpsAutoCrawler",
"automationAccRunbookName": "DevOpsAutoCrawlerRunner",
"region": "West Europe"
}

Links that helped me put this together:

https://social.technet.microsoft.com/wiki/contents/articles/52476.azure-create-runbook-and-add-schedules-using-powershell.aspx
https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-subscription
https://docs.microsoft.com/en-us/powershell/azure/create-azure-service-principal-azureps?view=azps-3.4.0
https://adamtheautomator.com/powershell-get-credential/
