# variables.tf
variable "resource_group_name" {
  description = "AKS-RG"
  type        = string
  default     = "aksRG"
}

variable "location" {
  description = "East US"
  type        = string
  default     = "East US"
}




