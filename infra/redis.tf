
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
              memory = "1Gi"
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
}

# -----------------------------
# Redis Commander (Namespace: prod)
# -----------------------------

resource "kubernetes_deployment_v1" "redis_commander" {
  metadata {
    name      = "redis-commander"
    namespace = "prod"
    labels = {
      app = "redis-commander"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis-commander"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis-commander"
        }
      }

      spec {
        container {
          name  = "redis-commander"
          image = "rediscommander/redis-commander:latest"

          port {
            container_port = 8081
          }

          env {
            name  = "REDIS_HOSTS"
            value = "prod:redis-master.prod.svc.cluster.local:6379,dev:redis-master.dev.svc.cluster.local:6379"
          }

          # Optional: Basic Auth (if needed later)
          # env {
          #   name = "HTTP_USER"
          #   value = "admin" 
          # }
          # env {
          #   name = "HTTP_PASSWORD"
          #   value = "secret"
          # }

          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "redis_commander" {
  metadata {
    name      = "redis-commander"
    namespace = "prod"
  }

  spec {
    selector = {
      app = "redis-commander"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8081
    }

    type = "ClusterIP"
  }
}