terraform {
  cloud {

    organization = "protien_compute"

    workspaces {
      name = "protien_state"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

locals {
  resource_group_name      = "${var.environment}-${var.project_name}-rg"
  azure_batch_account_name = "${var.environment}${var.project_name}ba001"
  azure_batch_pool_name    = "${var.environment}${var.project_name}ba-pool-001"
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

resource "azurerm_batch_pool" "example" {
  name                = local.azure_batch_pool_name
  resource_group_name = local.resource_group_name
  account_name        = local.azure_batch_account_name
  display_name        = local.azure_batch_pool_name
  vm_size             = "Standard_A1"
  node_agent_sku_id   = "batch.node.ubuntu 22.04"

  fixed_scale {
    target_dedicated_nodes = 1
    resize_timeout         = "PT15M"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}
