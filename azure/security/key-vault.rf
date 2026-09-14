# Maintained directly from pinned provider evidence.
concept "key-vault" {
  description = "An Azure Key Vault security boundary for keys, secrets, and certificates."
}

rule "key-vault" {
  match {
    type = "azurerm_key_vault"
  }

  as = concept.key-vault

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "key-vault-access-policy" {
  match {
    type = "azurerm_key_vault_access_policy"
  }

  as = concept.security-detail

  contribution {
    to  = concept.key-vault
    via = source.key_vault_id
  }
}

rule "key-vault-certificate" {
  match {
    type = "azurerm_key_vault_certificate"
  }

  as = concept.security-detail

  contribution {
    to  = concept.key-vault
    via = source.key_vault_id
  }
}

rule "key-vault-key" {
  match {
    type = "azurerm_key_vault_key"
  }

  as = concept.encryption-key

  context {
    as  = context.ownership
    to  = concept.key-vault
    via = source.key_vault_id
  }
}

rule "key-vault-secret" {
  match {
    type = "azurerm_key_vault_secret"
  }

  as = concept.managed-secret

  context {
    as  = context.ownership
    to  = concept.key-vault
    via = source.key_vault_id
  }
}

rule "managed-hsm" {
  match {
    type = "azurerm_key_vault_managed_hardware_security_module"
  }

  as = concept.managed-hsm

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "managed-hsm-key" {
  match {
    type = "azurerm_key_vault_managed_hardware_security_module_key"
  }

  as = concept.encryption-key

  context {
    as  = context.ownership
    to  = concept.managed-hsm
    via = source.managed_hsm_id
  }
}
