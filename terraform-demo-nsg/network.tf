resource "azurerm_virtual_network" "demo" {
  name = "${var.prefix}-network"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "demo-internal-1" {
  name = "${var.prefix}-internal-1"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "allow-ssh" {
  name = "${var.prefix}-allow-ssh"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name

    security_rule = [ {
      name = "Allow-SSH"
      access = "Allow"
      description = "Allow SSH from a single PIP"
      destination_address_prefix = "*"
      destination_address_prefixes = null
      destination_application_security_group_ids  = null
      destination_port_ranges = null
      destination_port_range = "22"
      direction = "Inbound"
      priority = 1001
      protocol = "Tcp"
      source_address_prefix = var.ssh-source-address
      source_address_prefixes = null
      source_application_security_group_ids = null
      source_port_range = "*"
      source_port_ranges = null
    } ]
}

resource "azurerm_network_security_group" "internal-facing" {
  name = "${var.prefix}-internal-facing"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name
  depends_on = [
   azurerm_application_security_group.demo-internet-group
  ]
  security_rule = [ {
        name = "test-rule-allow"
        description = "Allow port 80 from Application Group"
        priority = 1001
        access = "Allow"
        destination_address_prefix = "*" 
        destination_address_prefixes = null
        destination_application_security_group_ids = null
        destination_port_range = "80"
        destination_port_ranges = null
        direction = "Inbound"
        protocol = "Tcp"
        source_address_prefix = null
        source_address_prefixes =  null
        source_application_security_group_ids = [azurerm_application_security_group.demo-internet-group.id]
        source_port_range = "*"
        source_port_ranges = null
    },
    {
        name = "test-rule-deny"
        description = "Deny all traffic"
        priority = 1002
        access = "Deny"
        destination_address_prefix = "*" 
        destination_address_prefixes = null
        destination_application_security_group_ids = null
        destination_port_range = "*"
        destination_port_ranges = null
        direction = "Inbound"
        protocol = "Tcp"
        source_address_prefix = "*"
        source_address_prefixes =  null
        source_application_security_group_ids = null
        source_port_range = "*"
        source_port_ranges = null
    }
  ]
}