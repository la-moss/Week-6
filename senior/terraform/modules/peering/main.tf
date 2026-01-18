resource "azurerm_virtual_network_peering" "primary_to_secondary" {
  name                      = "peer-primary-to-secondary"
  resource_group_name       = var.rg_primary_name
  virtual_network_name      = var.vnet_primary_name
  remote_virtual_network_id = var.vnet_secondary_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
