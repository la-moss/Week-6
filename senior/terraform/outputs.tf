output "primary_key_vault_id" {
  value = module.keyvault_primary.key_vault_id
}

output "secondary_key_vault_id" {
  value = module.keyvault_secondary.key_vault_id
}

output "log_analytics_workspace_id" {
  value = module.monitoring.log_analytics_workspace_id
}
