# main.tf
module "networking" {
  source = "./network"
  resource_group_name = var.resource_group_name
  location = var.location
  aks_subnet_id = module.networking.aks_subnet_id
}

module "aks" {
  source = "./aks"
  aks_subnet_id = module.networking.aks_subnet_id
  resource_group_name = var.resource_group_name
  location = var.location
}


module "storage" {
  source = "./storage"
  resource_group_name = var.resource_group_name
  location = var.location
}






