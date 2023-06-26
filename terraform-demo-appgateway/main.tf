resource "azurerm_resource_group" "demo" {
  name = "rg-appgw-demo"
  location = var.location
}