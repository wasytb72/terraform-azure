#First Demo instance (access from internet via SSH)
resource "azurerm_linux_virtual_machine" "demo-vm1" {
  name = "${var.prefix}-vm"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name
  network_interface_ids = [azurerm_network_interface.demo-vm1-1.id]
  size = var.vm-size
  admin_username = "wasytb"

    admin_ssh_key {
      username = "wasytb"
      public_key = file("~/.ssh/authorized_keys/terrademo.pub")
    }

    source_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "16.04-LTS"
      version = "latest"
    }
    os_disk {
      storage_account_type = "Standard_LRS"
      caching = "ReadWrite"
    }
}

resource "azurerm_network_interface" "demo-vm1-1" {
  name = "${var.prefix}-vm1-nic"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name
  #From terraform >2.0 we need to put this in a separate resource
  # See azurerm_network_interface_security_group association below
  #network_security_group_id = azurerm_network_security_group.allow-ssh.id

  ip_configuration {
    name = "ipconfig"
    subnet_id = azurerm_subnet.demo-internal-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.demo-vm-1.id
  }
}

resource "azurerm_network_interface_security_group_association" "demo-nic-1" {
  network_interface_id = azurerm_network_interface.demo-vm1-1.id
  network_security_group_id = azurerm_network_security_group.allow-ssh.id
}

resource "azurerm_public_ip" "demo-vm-1" {
  name = "${var.prefix}-vm1-pip"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method = "Dynamic"
}

resource "azurerm_application_security_group" "demo-internet-group" {
  name = "internet-facing"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name
}


resource "azurerm_network_interface_application_security_group_association" "demo-instance-group" {
  network_interface_id = azurerm_network_interface.demo-vm1-1.id
  application_security_group_id = azurerm_application_security_group.demo-internet-group.id
}

#demo instance 2
resource "azurerm_linux_virtual_machine" "demo-vm2" {
  name = "${var.prefix}-vm2"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name
  network_interface_ids = [azurerm_network_interface.demo-vm2-1.id]
  size = var.vm-size
  admin_username = "wasytb"

    admin_ssh_key {
      username = "wasytb"
      public_key = file("~/.ssh/authorized_keys/terrademo.pub")
    }

    source_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "16.04-LTS"
      version = "latest"
    }
    os_disk {
      storage_account_type = "Standard_LRS"
      caching = "ReadWrite"
    }
}

resource "azurerm_network_interface" "demo-vm2-1" {
  name = "${var.prefix}-vm2-nic"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name
  #From terraform >2.0 we need to put this in a separate resource
  # See azurerm_network_interface_security_group association below
  #network_security_group_id = azurerm_network_security_group.allow-ssh.id

  ip_configuration {
    name = "ipconfig"
    subnet_id = azurerm_subnet.demo-internal-1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "demo-internal" {
  network_interface_id = azurerm_network_interface.demo-vm2-1.id
  network_security_group_id = azurerm_network_security_group.internal-facing.id
}