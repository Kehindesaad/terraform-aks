resource "kubernetes_namespace" "python_app_ns" {
  metadata {
    name = "my-python-app"
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "kubernetes_manifest" "python_app_service" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "python-app-service"
      namespace = "my-python-app"
    }
    spec = {
      selector = {
        app = "python-app"
      }
      ports = [{
        port       = 80      # The external port (clients will hit this)
        targetPort = 8000    # The port on which the Python app listens
      }]
    }
  }
}

resource "kubernetes_manifest" "python_app_deployment" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "python-app"
      namespace = "my-python-app"
    }
    spec = {
      replicas = 2
      selector = {
        matchLabels = {
          app = "python-app"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "python-app"
          }
        }
        spec = {
          containers = [{
            name  = "python-app-container"
            image = "saadudeenregistry247.azurecr.io/python-app:v1"   # ACR image
            ports = [{
              containerPort = 8000   # Updated to match the Python app
            }]
          }]
        }
      }
    }
  }
}