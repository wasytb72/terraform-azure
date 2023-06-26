#Create a resource group

resource "azurerm_resource_group" "demo" {
 name = var.resource_group_prefix
 location = var.resource_group_location 
}

#Generate random value for the name
resource "random_string" "name" {
  length = 8
  lower = true
  numeric = false
  special = false
  upper = false
}

#Generate random value for login password
resource "random_password" "password" {
  length = 8
  lower = true
  min_lower = 1
  min_numeric = 1
  min_special = 1
  numeric = true
  override_special = "_"
  special = true
  upper = true
}