variable "kubeconfig_path" {
  description = "Path to Kubernetes kubeconfig"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubernetes context name"
  type        = string
}

variable "project_name" {
  description = "Project identifier"
  type        = string
  default     = "secure-devsecops"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "lab"
}
