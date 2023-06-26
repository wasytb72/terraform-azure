output "azurerm_mysql_flexible_server" {
  value = azurerm_mysql_flexible_server.demo.name
}

output "admin_login" {
  value = azurerm_mysql_flexible_server.demo.administrator_login
}

output "admin_password" {
  sensitive = true
  value = azurerm_mysql_flexible_server.demo.administrator_password
}

output "my_flexible_server_database_name" {
  value = azurerm_mysql_flexible_database.demo.name
}

output "resource_group_name" {
  value = azurerm_resource_group.demo.name
}