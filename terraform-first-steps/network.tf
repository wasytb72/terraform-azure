resource "azurerm_virtual_network" "demo" {
  name = "${var.prefix}-network"
  location = var.location
  resource_group_name = azurerm_resource_group.demoterraform.name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "demo-internal-1" {
  name = "${var.prefix}-subnet-1"
  resource_group_name = azurerm_resource_group.demoterraform.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "allow-ssh" {
  name = "${var.prefix}-nsg-allow-ssh"
  location = var.location
  resource_group_name = azurerm_resource_group.demoterraform.name

  security_rule = [ {
    access = "Allow"
    description = "Permit SSH"
    destination_address_prefix = "*"
    destination_address_prefixes = [ ]
    destination_application_security_group_ids = [ ]
    destination_port_range = "22"
    destination_port_ranges = [ ]
    direction = "Inbound"
    name = "Allow-SSH"
    priority = 1001
    protocol = "Tcp"
    source_address_prefix = var.ssh-source-address
    source_address_prefixes = [ ]
    source_application_security_group_ids = [ ]
    source_port_range = "*"
    source_port_ranges = [ ]
  } ]
}


resource "azurerm_network_interface" "demo-instance" {
  name = "${var.prefix}-nic1"
  location = var.location
  resource_group_name = azurerm_resource_group.demoterraform.name
  


ip_configuration {
  name = "instance1"
  subnet_id = azurerm_subnet.demo-internal-1.id
  private_ip_address_allocation = "Dynamic"
  public_ip_address_id = azurerm_public_ip.demo-instance.id
  }
}

resource "azurerm_network_interface_security_group_association" "demo" {
  count = 1
  network_interface_id = azurerm_network_interface.demo-instance.id
  network_security_group_id = azurerm_network_security_group.allow-ssh.id
}

resource "azurerm_public_ip" "demo-instance" {
  name = "instance1-public-ip"
  location = var.location
  resource_group_name = azurerm_resource_group.demoterraform.name
  allocation_method = "Dynamic"

}