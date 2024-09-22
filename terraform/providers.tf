# providers.tf
provider "azurerm" {
  features {}
  subscription_id = "ba85713b-a9b8-4e7c-a373-da0bf7a68327"
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks-istio-cluster.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks-istio-cluster.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks-istio-cluster.kube_config[0].cluster_ca_certificate)
  }
}