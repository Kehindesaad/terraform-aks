resource "kubernetes_manifest" "istio_gateway" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "Gateway"
    metadata = {
      name      = "my-istio-gateway"
      namespace = "istio-system"
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [{
        port = {
          number   = 80
          name     = "http"
          protocol = "HTTP"
        }
        hosts = ["*"]
      }]
    }
  }
}

resource "kubernetes_manifest" "istio_virtualservice" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = "python-app"
      namespace = "my-python-app"
    }
    spec = {
      hosts = ["*"]
      gateways = ["my-istio-gateway"]
      http = [{
        match = [{
          uri = {
            exact = "/"
          }
        }]
        route = [{
          destination = {
            host = "python-app.default.svc.cluster.local"
            port = {
              number = 8000
            }
          }
        }]
      }]
    }
  }
}
