variable "name" { type = string }
variable "location" { type = string }
variable "tags" { type = map(string) }
variable "vnet_id" { type = string }
variable "subnet_id" { type = string }
variable "dns_zone_id" { type = string }
variable "log_analytics_workspace_id" { type = string }
