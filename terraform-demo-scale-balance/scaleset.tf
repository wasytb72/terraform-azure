resource "azurerm_linux_virtual_machine_scale_set" "demo" {
  name = "mytestscaleset-1"
  location = var.location
  resource_group_name = azurerm_resource_group.demo.name
  sku = "Standard_A1_v2"
  instances = 2
  upgrade_mode = "Automatic"
  admin_username = "wasytb"
  disable_password_authentication = true
  computer_name_prefix = "demo"
  custom_data = base64encode("#!/bin/bash\n\nsudo apt-get update && sudo apt-get install -y nginx && sudo systemctl enable nginx && systemctl start nginx")
  depends_on = [
    azurerm_lb_probe.demo
  ]
  
  #Automatic rolling upgrade
  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = true
    disable_automatic_rollback = false
  }
  

  rolling_upgrade_policy {
    max_batch_instance_percent = 50
    max_unhealthy_upgraded_instance_percent = 50
    max_unhealthy_instance_percent = 50
    pause_time_between_batches = "PT0S"
  }

  #required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.demo.id

  zones = var.zones


  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
  
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  data_disk {
    #name = ""
    lun = 0
    caching = "ReadWrite"
    create_option = "Empty"
    disk_size_gb = 10
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username = "wasytb"
    public_key = file("~/.ssh/authorized_keys/terrademo.pub")
  }

  network_interface {
    name = "demo-nic"
    primary = true
    ip_configuration {
    name = "IPConfiguration"
    primary = true
    subnet_id = azurerm_subnet.demo-subnet-1.id
    load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bepool.id]
    load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.lbnatpool.id]
    }  
  }

}