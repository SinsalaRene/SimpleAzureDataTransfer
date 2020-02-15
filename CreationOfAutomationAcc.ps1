# Load config file
$Config = Get-Content ".\PowershellScriptConfig.json" -Raw | ConvertFrom-Json

#Build the credentials for the service principal
$password = ConvertTo-SecureString $Config.clientSecret -AsPlainText -Force
$username = $Config.clientId
$credential = New-Object System.Management.Automation.PSCredential ($username, $password)

# Login in to the right Acc
Connect-AzAccount -ServicePrincipal -Credential $credential -Tenant $Config.tenantId
# Set the context to the right subscription
Select-AzSubscription -Subscription $Config.subscriptionId
# Create ResourceGroup
#Check what happens if it exists already?
New-AzResourceGroup -Name $Config.resourceGroupName -Location $Config.region -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Force
# Create Automation Account
New-AzAutomationAccount -ResourceGroupName $Config.resourceGroupName -Name $Config.automationAccName -Location $Config.region -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
# Create Runbook
New-AzAutomationRunbook -Name $Config.automationAccRunbookName -ResourceGroupName $Config.resourceGroupName -AutomationAccountName $Config.automationAccName -Type PowerShell -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
# Can you even deploy a runbook from powershell?
Import-AzAutomationRunbook -AutomationAccountName $Config.automationAccName -ResourceGroupName $Config.resourceGroupName  -Path ".\DataCrawler.ps1" -Name $Config.automationAccRunbookName -Type PowerShell -Force
#You need to publish the runbook to start it or create a webhook
Publish-AzAutomationRunbook -AutomationAccountName $Config.automationAccName -ResourceGroupName $Config.resourceGroupName -Name $Config.automationAccRunbookName
#For security purposes, the URL of the created webhook will only be viewable in the output of this command. No other commands will return the webhook URL. Make sure to copy down the webhook URL from this
#command's output before closing your PowerShell session, and to store it securely
New-AzAutomationWebhook -AutomationAccountName $Config.automationAccName -ResourceGroupName $Config.resourceGroupName -Name $Config.automationAccRunbookName -RunbookName $Config.automationAccRunbookName -IsEnabled $true -ExpiryTime "2020-12-12"

#This webhook then needs to be configured in the environment variables of the function app. How to do this though without having it in the serverless.yml?
 