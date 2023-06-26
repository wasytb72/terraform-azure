resource "azurerm_virtual_network" "demo" {
  name                = "demo-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "demo-subnet-1" {
  name                 = "demo-subnet-1"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "demo-subnet-2" {
  name                 = "demo-subnet-2"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "demo-instance" {
  name = "${var.prefix}-allow-ssh"
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

    security_rule = [ //All the parameters must me included, null when empty
        {
            name = "SSH"
            priority = 1002
            direction = "Inbound"
            access = "Allow"
            protocol = "Tcp"
            source_port_range = "*"
            destination_port_range = "22"
            source_address_prefix = "*"
            destination_address_prefix = "*"
            destination_address_prefixes = null
            source_application_security_group_ids = null
            source_port_ranges = null
            description = null
            destination_application_security_group_ids = null
            destination_port_ranges = null
            source_address_prefixes = null
        },
        {
            name = "HTTP"
            priority = 1001
            direction = "Inbound"
            access = "Allow"
            protocol = "Tcp"
            source_port_range = "*"
            destination_port_range = "80"
            source_address_prefix = "*"
            destination_address_prefix = "*"
            destination_address_prefixes = null
            source_application_security_group_ids = null
            source_port_ranges = null
            description = null
            destination_application_security_group_ids = null
            destination_port_ranges = null
            source_address_prefixes = null
        }
    ]
    
}