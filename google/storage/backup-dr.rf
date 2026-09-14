rule "backup-dr-backup-vault" {
  match {
    type = "google_backup_dr_backup_vault"
  }

  as = concept.backup-vault
}

rule "backup-dr-backup-plan" {
  match {
    type = "google_backup_dr_backup_plan"
  }

  as = concept.backup-plan

  relation "stores-in" {
    to  = concept.backup-vault
    via = source.backup_vault
  }
}
