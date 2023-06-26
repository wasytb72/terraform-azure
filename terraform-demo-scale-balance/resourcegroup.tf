resource "azurerm_resource_group" "demo" {
  name = "demo-terraform-scaling"
  location = var.location
}