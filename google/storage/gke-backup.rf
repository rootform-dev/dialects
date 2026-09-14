
concept "gke-backup-channel" {
  description = "A Backup for GKE channel connecting backup or restore operations across projects."
}

rule "gke-backup-plan" {
  match {
    type = "google_gke_backup_backup_plan"
  }

  as = concept.backup-plan
}


rule "gke-backup-channel" {
  match {
    type = "google_gke_backup_backup_channel"
  }

  as = concept.gke-backup-channel
}

rule "gke-restore-channel" {
  match {
    type = "google_gke_backup_restore_channel"
  }

  as = concept.gke-backup-channel
}
