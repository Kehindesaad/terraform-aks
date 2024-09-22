resource "helm_release" "istio_base" {
  name       = "istio-base"
  namespace  = "istio-system"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.15.3"

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }
}

resource "helm_release" "istio_discovery" {
  name       = "istiod"
  namespace  = "istio-system"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.15.3"

  depends_on = [helm_release.istio_base]

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }
}

resource "helm_release" "istio_gateway" {
  name       = "istio-ingressgateway"
  namespace  = "istio-system"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "1.15.3"

  depends_on = [helm_release.istio_discovery]

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }

  set {
    name  = "gateways.istio-ingressgateway.enabled"
    value = "true"
  }
}