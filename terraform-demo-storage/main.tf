provider "azurerm" {
    features {
      
    }
}


# Create a resource group
resource "azurerm_resource_group" "demo" {
  name     = "tf-demo-storage"
  location = var.location
}