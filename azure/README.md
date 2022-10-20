https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-node?tabs=azure-cli%2Cbrowser

### Setup Azure CLI

Install Azure CLI and Azure functions core tools

### Setup Azure resources

Resource group and storage account need to be done once

Function app needs to be done once per sdk language

create resource group if not already created
```
az group create --name sdk-faas-testing --location eastus
```

create storage account
```
az storage account create --name sdkfaastesting --location eastus --resource-group sdk-faas-testing --sku Standard_LRS
```

create function app
```
az functionapp create --os linux --resource-group sdk-faas-testing --consumption-plan-location eastus --runtime node --runtime-version 16 --functions-version 4 --name sdk-faas-testing-azure-nodejs --storage-account sdkfaastesting
```

### Create new function

create function directory structure

```
func init nodejs --javascript
```

create function boilerplate code

```
cd nodejs
func new --name sdk-faas-testing-azure-nodejs --template "HTTP trigger" --authlevel "anonymous"
```

### Deloy function

```
func azure functionapp publish sdk-faas-testing-azure-nodejs
```