variable "project" {
  type        = string
  description = "Workload identifier used in names."
  default     = "plat-sec"
}

variable "primary_location" {
  type        = string
  description = "Primary Azure region."
  default     = "westeurope"
}

variable "secondary_location" {
  type        = string
  description = "Secondary Azure region."
  default     = "northeurope"
}

variable "owner" {
  type        = string
  description = "Owner tag value."
}

variable "cost_center" {
  type        = string
  description = "CostCenter tag value."
}

variable "environment" {
  type        = string
  description = "Environment tag value."
  default     = "prod"
}
