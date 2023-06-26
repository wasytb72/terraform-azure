resource "azurerm_linux_virtual_machine" "demo-instance" {
  name = "${var.prefix}-vm"
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  network_interface_ids = [ "${azurerm_network_interface.demo-instance.id}" ]
  size = "Standard_A1_v2"
  admin_username = "wasytb"


  disable_password_authentication = true # change to false if you wat ti use a password key instead of ssh key
  #admin_password = ""

  admin_ssh_key {
    username = "wasytb"
    public_key = file("~/.ssh/authorized_keys/terrademo.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
  os_disk {
    name = "myosdisk1"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}

resource "azurerm_network_interface" "demo-instance" {
  name = "${var.prefix}-instance1"
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name = "instance1"
    subnet_id = azurerm_subnet.demo-internal-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.demo-instance.id
  }
}

 resource "azurerm_network_interface_security_group_association" "demo-instance" {
    network_interface_id = azurerm_network_interface.demo-instance.id
    network_security_group_id = azurerm_network_security_group.allow-ssh.id

 }

 resource "azurerm_public_ip" "demo-instance" {
    name = "instance1-public-ip"
    location = azurerm_resource_group.demo.location
    resource_group_name = azurerm_resource_group.demo.name
    allocation_method = "Dynamic"
   
 }