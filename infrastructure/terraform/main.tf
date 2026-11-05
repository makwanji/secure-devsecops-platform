resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"

    labels = {
      project     = var.project_name
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}

resource "kubernetes_namespace_v1" "application" {
  metadata {
    name = "devsecops-demo"

    labels = {
      project     = var.project_name
      environment = var.environment
      managed-by  = "terraform"
      application = "devsecops-demo"
    }
  }
}

resource "kubernetes_resource_quota_v1" "application" {
  metadata {
    name      = "application-quota"
    namespace = kubernetes_namespace_v1.application.metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = "2"
      "requests.memory" = "4Gi"
      "limits.cpu"      = "4"
      "limits.memory"   = "8Gi"
      "pods"            = "20"
    }
  }
}
