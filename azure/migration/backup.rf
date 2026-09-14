# Maintained directly from pinned provider evidence.
rule "backup-protected-vm" {
  match {
    type = "azurerm_backup_protected_vm"
  }

  as = concept.site-recovery-detail
}

rule "file-share-backup-policy" {
  match {
    type = "azurerm_backup_policy_file_share"
  }

  as = concept.backup-plan

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "recovery-services-vault" {
  match {
    type = "azurerm_recovery_services_vault"
  }

  as = concept.backup-vault

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "virtual-machine-backup-policy" {
  match {
    type = "azurerm_backup_policy_vm"
  }

  as = concept.backup-plan

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
