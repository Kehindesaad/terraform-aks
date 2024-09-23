# aks/variables.tf
variable "location" {
  description = "East US"
  type        = string
}

variable "resource_group_name" {
  description = "AKS-RG"
  type        = string
}

variable "aks_subnet_id" {
  description = " "
  type        = string
}


