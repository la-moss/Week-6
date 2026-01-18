locals {
  base_tags = {
    Owner      = var.owner
    CostCenter = var.cost_center
    Environment = var.environment
    Project    = var.project
  }
}

module "network_primary" {
  source   = "./modules/network"
  name     = "${var.project}-net-pri"
  location = var.primary_location
  tags     = local.base_tags
}

module "network_secondary" {
  source    = "./modules/network"
  providers = { azurerm = azurerm.secondary }

  name     = "${var.project}-net-sec"
  location = var.secondary_location
  tags     = local.base_tags
}

module "monitoring" {
  source   = "./modules/monitoring"
  name     = "${var.project}-mon"
  location = var.primary_location
  tags     = local.base_tags
}

module "keyvault_primary" {
  source   = "./modules/keyvault"
  name     = "${var.project}-kv-pri"
  location = var.primary_location
  tags     = local.base_tags

  vnet_id     = module.network_primary.vnet_id
  subnet_id   = module.network_primary.private_endpoints_subnet_id
  dns_zone_id = module.private_dns.zone_id

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
}

module "keyvault_secondary" {
  source    = "./modules/keyvault"
  providers = { azurerm = azurerm.secondary }

  name     = "${var.project}-kv-sec"
  location = var.secondary_location

  # Intentionally uses a slightly different tag surface
  tags = merge(local.base_tags, { })

  vnet_id     = module.network_secondary.vnet_id
  subnet_id   = module.network_secondary.private_endpoints_subnet_id
  dns_zone_id = module.private_dns.zone_id

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
}

module "private_dns" {
  source   = "./modules/private_dns"
  name     = "${var.project}-privdns"
  location = var.primary_location
  tags     = local.base_tags

  primary_vnet_id   = module.network_primary.vnet_id
  secondary_vnet_id = module.network_secondary.vnet_id
}

module "identity" {
  source   = "./modules/identity"
  name     = "${var.project}-id"
  location = var.primary_location
  tags     = local.base_tags
}

module "rbac" {
  source = "./modules/rbac"
  name   = "${var.project}-rbac"

  principal_id = module.identity.principal_id
  rg_id_primary = module.network_primary.resource_group_id
  subscription_scope = "/subscriptions/00000000-0000-0000-0000-000000000000"

  tags = local.base_tags
}

module "peering" {
  source = "./modules/peering"

  vnet_primary_id   = module.network_primary.vnet_id
  vnet_secondary_id = module.network_secondary.vnet_id
  vnet_primary_name = module.network_primary.vnet_name
  vnet_secondary_name = module.network_secondary.vnet_name
  rg_primary_name   = module.network_primary.resource_group_name
  rg_secondary_name = module.network_secondary.resource_group_name
}
