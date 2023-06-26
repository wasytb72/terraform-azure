resource "azurerm_virtual_network" "demo" {
    name                = "${var.prefix}-network"
    location            = var.location
    resource_group_name = azurerm_resource_group.demoterraform.name
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "demo-internal-1" {
    name                        = "var.prefix-internal-1"
    resource_group_name         = azurerm_resource_group.demoterraform.name
    virtual_network_name        = azurerm_virtual_network.demo.name
    address_prefixes              = ["10.0.0.0/24"]      
}

resource azurerm_network_security_group "allow-sh" {
    name                        = "${var.prefix}-allow-sh"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.demoterraform.name

    security_rule {
        name                        = "SSH"
        priority                    = 1001
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = var.ssh-source-address
        destination_address_prefix  = "*"
    }
}

resource "azurerm_network_interface" "demo-instance" {
    name                                    = "${var.prefix}-nic"
    location                                = var.location
    resource_group_name                     = azurerm_resource_group.demoterraform.name

    ip_configuration {
        name                                = "instance"
        subnet_id                           = azurerm_subnet.demo-internal-1.id
        private_ip_address_allocation       = "Dynamic"
        public_ip_address_id                = azurerm_public_ip.demo-instance.id
    }
}

resource "azurerm_subnet_network_security_group_association" "demo-nsg-subnet" {
    subnet_id                   = azurerm_subnet.demo-internal-1.id
    network_security_group_id   = azurerm_network_security_group.allow-sh.id
  
}

resource "azurerm_public_ip" "demo-instance" {
    name                                    = "${var.prefix}-public-ip"
    location                                = var.location
    resource_group_name                     = azurerm_resource_group.demoterraform.name
    allocation_method                       = "Dynamic"
}