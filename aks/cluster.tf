# aks/cluster.tf
resource "azurerm_kubernetes_cluster" "aks-istio-cluster" {
  name                = "aks-istio-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aksdns"

  default_node_pool {
    name       = "agentpool"
    node_count = 1
    auto_scaling_enabled = true 
    min_count           = 1         
    max_count           = 2        
    vm_size    = "standard_d16ps_v5"
    vnet_subnet_id = var.aks_subnet_id
  }
  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.1.0.0/16"   
    dns_service_ip = "10.1.0.10"
    # docker_bridge_cidr = "172.17.0.1/16"
  }


  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.aks-istio-cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.saadudeenregistry247.id
  skip_service_principal_aad_check = true
}





