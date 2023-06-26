provider "azurerm" {
  features {
    
  }
}
resource "azurerm_resource_group" "demo" {
  name = "resource-group-demo"
  location = var.location
  tags = {
    "env" = "demo"
  }
}