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