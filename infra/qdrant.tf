resource "kubernetes_stateful_set_v1" "qdrant_prod" {
  metadata {
    name      = "qdrant"
    namespace = "prod"
  }

  spec {
    service_name = "qdrant"
    replicas     = 1

    selector {
      match_labels = { app = "qdrant" }
    }

    template {
      metadata {
        labels = { app = "qdrant" }
      }

      spec {
        container {
          name  = "qdrant"
          image = "qdrant/qdrant:v1.16.1"

          port {
            container_port = 6333
          }

          resources {
            requests = {
              cpu    = "500m"
              memory = "1Gi"
            }
            limits = {
              cpu    = "1"
              memory = "2Gi"
            }
          }
        }
      }
    }

  }
}

resource "kubernetes_service_v1" "qdrant_prod_service" {
  metadata {
    name      = "qdrant"
    namespace = "prod"
  }

  spec {
    selector = { app = "qdrant" }

    port {
      port        = 6333
      target_port = 6333
    }

    type = "ClusterIP"
  }

  depends_on = [kubernetes_stateful_set_v1.qdrant_prod]
}

