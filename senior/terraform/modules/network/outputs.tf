output "resource_group_name" { value = azurerm_resource_group.rg.name }
output "resource_group_id" { value = azurerm_resource_group.rg.id }
output "vnet_id" { value = azurerm_virtual_network.vnet.id }
output "vnet_name" { value = azurerm_virtual_network.vnet.name }
output "private_endpoints_subnet_id" { value = azurerm_subnet.private_endpoints.id }
