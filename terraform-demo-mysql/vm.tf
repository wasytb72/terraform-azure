#demo instance
 resource "azurerm_virtual_machine" "demo-instance" {
    name                    = "${random_string.name.result}-vm"
    location                = var.resource_group_location
    resource_group_name     = azurerm_resource_group.demo.name
    network_interface_ids   = [azurerm_network_interface.demo.id]
    vm_size                 = "Standard_A1_V2"

#This is a demo instance so we can delete all data on termination
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_image_reference {
        publisher   =  "Canonical"
        offer       = "UbuntuServer"
        sku         = "16.04-LTS"
        version     = "latest"
    }

    storage_os_disk {
        name                = "myosdisk"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Standard_LRS"
    }

    os_profile {
        computer_name       = "demo-instance"
        admin_username      = "wasytb"
        #admin_password     = "..."
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            key_data = file("/home/wasytb/.ssh/authorized_keys/terrademo.pub")
            path     = "/home/wasytb/.ssh/authorized_keys"
        }   
    }
}