# storage/storage_account.tf
resource "azurerm_storage_account" "saadudeenstorage247" {
  name                     = "saadudeenstorage247"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "aks-database" {
  name                  = "aks-database"
  storage_account_name  = azurerm_storage_account.saadudeenstorage247.name
  container_access_type = "private"
}
