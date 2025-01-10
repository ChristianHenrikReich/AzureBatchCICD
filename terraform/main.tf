terraform { 
  cloud { 
    
    organization = "HPC_boilerplate" 

    workspaces { 
      name = "AzureBatchBoilerPlate" 
    } 
  } 
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

locals {
  resource_group_name        = "${var.environment}-${var.project_name}-rg"
  azure_storage_account_name = "${var.environment}${var.project_name}st001"
  azure_batch_account_name   = "${var.environment}${var.project_name}ba001"
  azure_batch_pool_name      = "${var.environment}${var.project_name}ba001-pool-001"
}

resource "azurerm_resource_group" "example" {
 name     = local.resource_group_name
 location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = local.azure_batch_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_batch_account" "example" {
  name                                = local.azure_batch_account_name
  location                            = var.location
  resource_group_name                 = azurerm_resource_group.example.name
  storage_account_id                  = azurerm_storage_account.example.id
  storage_account_authentication_mode = "StorageKeys"
}

resource "azurerm_batch_pool" "example" {
  name                = local.azure_batch_pool_name
  resource_group_name = azurerm_batch_account.example.resource_group_name
  account_name        = azurerm_batch_account.example.name
  display_name        = local.azure_batch_pool_name
  vm_size             = var.vm_sku
  node_agent_sku_id   = var.node_agent_sku_id

  fixed_scale {
    target_dedicated_nodes    = var.nodes
    target_low_priority_nodes = var.spot_nodes
    resize_timeout            = "PT15M"
  }
  storage_image_reference {
    publisher = var.storage_image_reference_publisher
    offer     = var.storage_image_reference_offer
    sku       = var.storage_image_reference_sku
    version   = var.storage_image_reference_version
  }

}
