# main.tf
module "networking" {
  source = "/Users/saad/AKS/network"
  resource_group_name = var.resource_group_name
  location = var.location
  aks_subnet_id = module.networking.aks_subnet_id
}

module "aks" {
  source = "/Users/saad/AKS/aks"
  aks_subnet_id = module.networking.aks_subnet_id
  resource_group_name = var.resource_group_name
  location = var.location
}


module "storage" {
  source = "/Users/saad/AKS/storage"
  resource_group_name = var.resource_group_name
  location = var.location
}



