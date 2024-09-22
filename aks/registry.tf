resource "azurerm_container_registry" "saadudeenregistry247" {
  name                = "saadudeenregistry247"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
identity {
    type = "SystemAssigned"
  }
}


