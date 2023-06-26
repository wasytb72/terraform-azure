resource "azurerm_virtual_machine_scale_set" "demo" {
  name = "my-test-scaleset1"
  location = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  upgrade_policy_mode = "Manual"

  zones = var.zones

  sku {
    name = "Standard_A1_v2"
    tier = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }

  storage_profile_os_disk {
    name = ""
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun = 0
    caching = "ReadWrite"
    create_option = "Empty"
    disk_size_gb = 10
  }

  os_profile {
    computer_name_prefix = "demo"
    admin_username = "demo"
  }

  extension {
    name = "InstallCustomScript"
    publisher = "Microsoft.Azure.Extensions"
    type = "CustomScript"
    type_handler_version = "2.1"
    settings =jsonencode(
      {
          "fileUris": ["https://raw.githubusercontent.com/wasytb72/General/master/install_nginx.sh"], //added line to start nginx
          "commandToExecute": "sh install_nginx.sh"
        }
    )
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
        key_data = file("/home/wasytb/.ssh/authorized_keys/terrademo.pub")
        path     = "/home/demo/.ssh/authorized_keys"
    }
  }

  network_profile {
    name = "networkprofile"
    primary = true
    network_security_group_id = azurerm_network_security_group.demo-instance.id

    ip_configuration {
      name = "IPConfiguration"
      primary = true
      subnet_id = azurerm_subnet.demo-subnet-2.id
      application_gateway_backend_address_pool_ids = "${azurerm_application_gateway.demo.backend_address_pool[*].id}" //See Onenote
    }
  }
}