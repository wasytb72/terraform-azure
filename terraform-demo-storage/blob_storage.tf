resource "random_string" "random-name" {
  length = 5
  upper = false
  lower = false
  numeric = true
  special = false
}

resource "azurerm_storage_account" "trainingsa" {
  name = "trainingsa${random_string.random-name.result}"
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  account_tier = "Standard"
  account_replication_type = "LRS"
  
 network_rules {
   default_action = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.demo-internal-1.id]
  }
}

resource "azurerm_storage_container" "trainingco" {
  name = "trainingco${random_string.random-name.result}"
  storage_account_name = azurerm_storage_account.trainingsa.name
  container_access_type = "private"

}

resource "azurerm_storage_blob" "training-file" {
  name = "training_file.txt"
  storage_account_name = azurerm_storage_account.trainingsa.name
  storage_container_name = azurerm_storage_container.trainingco.name
   type = "Block"
  source = "training_file.txt"
}