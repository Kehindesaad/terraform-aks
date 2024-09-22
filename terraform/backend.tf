terraform {
  backend "azurerm" {
    resource_group_name  = "terraformstateRG"
    storage_account_name = "terraformstatefile99"
    container_name       = "terraformstatecontainer99"
    key                  = "terraform.tfstate"
    subscription_id = "ba85713b-a9b8-4e7c-a373-da0bf7a68327"
  }
  
}