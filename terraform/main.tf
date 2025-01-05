provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

locals {
  resource_group_name = "${var.environment}-${var.project_name}-rg"
  azure_batch_account_name = "${var.environment}${var.project_name}ba001"
}


#We can use the Terraform to create resource group.
#resource "azurerm_resource_group" "example" {
#  name     = local.resource_group_name
#  location = var.location
#}

resource "azurerm_batch_account" "example" {
  name                = local.azure_batch_account_name
  location            = var.location
  resource_group_name = local.resource_group_name
}

# resource "azurerm_batch_pool" "example" {
#   name                = "batchpoolexample"
#   resource_group_name = var.resource_group_name
#   batch_account_name  = azurerm_batch_account.example.name
#   vm_size             = "Standard_B1s" # Cheapest VM\n
#   node_agent_sku_id   = "batch.node.ubuntu 20.04"
#   target_dedicated_nodes = 1
# }
