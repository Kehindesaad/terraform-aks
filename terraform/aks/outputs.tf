output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks-istio-cluster.name
}

output "acr_login_server" {
  value = azurerm_container_registry.saadudeenregistry247.login_server
}