resource "azurerm_public_ip" "apgw-ip" {
  name                = "apgw-ip"
  sku                 = "Standard"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "aksappgateway" {
  name                = "aksappgateway"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.apgw-subnet.id
  }

  frontend_port {
    name = "my-frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name = "my-frontend-ip"
    public_ip_address_id = azurerm_public_ip.apgw-ip.id
  }

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "backend-http"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "http-listner"
    frontend_ip_configuration_name = "my-frontend-ip"
    frontend_port_name             = "my-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "request-routing"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "http-listner"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "backend-http"
  }
}


