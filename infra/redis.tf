
resource "kubernetes_deployment_v1" "redis_prod" {
  metadata {
    name      = "redis-master"
    namespace = "prod"
    labels = {
      app = "redis-master"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis-master"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis-master"
        }
      }

      spec {
        container {
          name  = "redis"
          image = "redis:7-alpine"

          port {
            container_port = 6379
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "1"
              memory = "512Mi"
            }
          }

          args = [
            "redis-server",
            "--save", "60", "1",
            "--appendonly", "yes"
          ]
        }
      }
    }
  }

  depends_on = [kubernetes_namespace_v1.prod]
}

resource "kubernetes_service_v1" "redis_prod" {
  metadata {
    name      = "redis-master"
    namespace = "prod"
  }

  spec {
    selector = {
      app = "redis-master"
    }

    port {
      port        = 6379
      target_port = 6379
    }

    type = "ClusterIP"
  }

  depends_on = [kubernetes_namespace_v1.prod]
}
