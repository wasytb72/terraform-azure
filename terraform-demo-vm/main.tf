
//Virtual Network
//Virtual Machine
//Storage
//Networn interface
//NSG
//Public IP


//Create a resource group
resource "azurerm_resource_group" "demoterraform" {
    name = "demoterraform"
    location = var.location
}