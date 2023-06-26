provider "azurerm" {
  features {
    
  }
}
# Create a resource group
resource "azurerm_resource_group" "demo" {
  name = "udemy-tf-sql-demo"
  location = var.location
}