resource "azurerm_public_ip" "demo" {
  name                = "demo-pip"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  allocation_method   = "Dynamic"
}


resource "azurerm_application_gateway" "demo" {
  name = "${var.prefix}-appgateway"
  resource_group_name = azurerm_resource_group.demo.name
  location = azurerm_resource_group.demo.location

  sku {
    name = "Standard_Small"
    tier = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name = "gateway-ip-config"
    subnet_id = azurerm_subnet.demo-subnet-1.id
  }

  frontend_port {
    name = "webAppPort"
    port = 80
  }

  frontend_ip_configuration {
    name = "webAppIP"
    public_ip_address_id = azurerm_public_ip.demo.id
  }

  backend_address_pool {
    name = "BackEndAddressPool"
  }

  backend_http_settings {
    name = "httpSetting"
    cookie_based_affinity = "Disabled"
    path = "/"
    port = 80
    protocol = "Http"
    request_timeout = 1
  }

  http_listener {
    name = "httpListener"
    frontend_ip_configuration_name = "webAppIP"
    frontend_port_name = "webAppPort"
    protocol = "Http"
  }

  request_routing_rule {
    name = "httpRoutingRule"
    rule_type = "Basic"
    http_listener_name = "httpListener"
    backend_address_pool_name = "backEndAddressPool"
    backend_http_settings_name = "httpSetting"
  }
}