provider "azurerm" {
  features {}
}

resource "azurerm_batch_account" "example" {
  name                = "batchaccountexample"
  location            = "East US"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_batch_pool" "example" {
  name                = "batchpoolexample"
  resource_group_name = azurerm_resource_group.example.name
  batch_account_name  = azurerm_batch_account.example.name
  vm_size             = "Standard_B1s" # Cheapest VM\n
  node_agent_sku_id   = "batch.node.ubuntu 20.04"
  target_dedicated_nodes = 1
}
