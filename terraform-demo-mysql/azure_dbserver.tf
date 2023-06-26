#Manages the MySQl Flexible Server
resource "azurerm_mysql_flexible_server" "demo" {
  location = azurerm_resource_group.demo.location
  name = "mysqlfs-${random_string.name.result}"
  resource_group_name = azurerm_resource_group.demo.name
  administrator_login = random_string.name.result
  administrator_password = random_password.password.result
  backup_retention_days = 1
  delegated_subnet_id = azurerm_subnet.demo-internal-1.id
  geo_redundant_backup_enabled = false
  private_dns_zone_id = azurerm_private_dns_zone.demo.id
  sku_name = "B_Standard_B1s"
  version = "8.0.21"
  #zone = "1"

  maintenance_window {
    day_of_week = 0
    start_hour = 8
    start_minute = 0
  }
  storage {
    iops = 360
    size_gb = 20
  }
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.demo
  ]
}
