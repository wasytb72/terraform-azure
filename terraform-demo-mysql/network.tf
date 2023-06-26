resource "azurerm_virtual_network" "demo" {
  name = "vnet-${random_string.name.result}"
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "demo-internal-1" {
  name = "subnet-${random_string.name.result}"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes = ["10.0.0.0/24"]
  service_endpoints = [ "Microsoft.Storage" ]
  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}
resource "azurerm_subnet" "db-subnet" {
  name = "subnet-${random_string.name.result}"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes = ["10.0.0.0/24"]
  service_endpoints = [ "Microsoft.Storage" ]
  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}
resource "azurerm_subnet" "vm-subnet" {
  name = "subnet-${random_string.name.result}-vm"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes = ["10.0.1.0/24"]
}

#Enables you to manage Private DNS zones withing Azure DNS
resource "azurerm_private_dns_zone" "demo" {
  name = "${random_string.name.result}.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.demo.name
}

#Enables you to manage Private DNS zone Virtual Network Links
resource "azurerm_private_dns_zone_virtual_network_link" "demo" {
  name = "mysqlfsVnetAzone${random_string.name.result}.com"
  private_dns_zone_name = azurerm_private_dns_zone.demo.name
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_id = azurerm_virtual_network.demo.id
}

#Public IP for the VM
resource "azurerm_public_ip" "demo" {
  name = "${random_string.name.result}-pip"
  resource_group_name = azurerm_resource_group.demo.name
  location = var.resource_group_location
  allocation_method = "Dynamic"
  domain_name_label = "${random_string.name.result}"
}

#NIC for the VM
resource "azurerm_network_interface" "demo" {
    name                                    = "${random_string.name.result}-nic"
    location                                = var.resource_group_location
    resource_group_name                     = azurerm_resource_group.demo.name

    ip_configuration {
        name                                = "instance"
        subnet_id                           = azurerm_subnet.vm-subnet.id
        private_ip_address_allocation       = "Dynamic"
        public_ip_address_id                = azurerm_public_ip.demo.id
    }
}
#NSG for the VM Subnet
resource azurerm_network_security_group "allow-sh" {
    name                        = "${random_string.name.result}-allow-sh"
    location                    = var.resource_group_location
    resource_group_name         = azurerm_resource_group.demo.name

    security_rule {
        name                        = "SSH"
        priority                    = 1001
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = var.ssh_source_address
        destination_address_prefix  = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "demo" {
    subnet_id                   = azurerm_subnet.demo-internal-1.id
    network_security_group_id   = azurerm_network_security_group.allow-sh.id
  
}