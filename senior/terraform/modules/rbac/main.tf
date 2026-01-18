resource "azurerm_role_definition" "custom" {
  name        = "rd-${var.name}"
  scope       = var.subscription_scope
  description = "Custom role for platform identity."

  permissions {
    actions = [
      "Microsoft.KeyVault/vaults/read",
      "Microsoft.KeyVault/vaults/secrets/read",
      "Microsoft.KeyVault/vaults/delete"
    ]
  }

  assignable_scopes = [
    var.subscription_scope
  ]
}

resource "azurerm_role_assignment" "custom" {
  scope              = var.subscription_scope
  role_definition_id = azurerm_role_definition.custom.role_definition_resource_id
  principal_id       = var.principal_id
}

resource "azurerm_role_assignment" "rg_owner" {
  scope                = var.rg_id_primary
  role_definition_name = "Owner"
  principal_id         = var.principal_id
}
