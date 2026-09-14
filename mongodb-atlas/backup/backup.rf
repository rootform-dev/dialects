concept "backup-export-destination" {
  description = "A MongoDB Atlas cloud backup export destination backed by customer object storage."
}

concept "backup-configuration" {
  description = "A backup compliance or retention configuration supporting an Atlas project."
}

rule "cloud-backup-schedule" {
  match {
    type = "mongodbatlas_cloud_backup_schedule"
  }

  as = concept.backup-plan

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "protects" {
    to  = rf.concept.managed-database
    via = source.cluster_name
  }

  relation "exports-to" {
    to  = concept.backup-export-destination
    via = source.export[0].export_bucket_id
  }
}

rule "cloud-backup-export-destination" {
  match {
    type = "mongodbatlas_cloud_backup_snapshot_export_bucket"
  }

  as = concept.backup-export-destination

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "stores-in" {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }

  relation "uses-cloud-authorization" {
    to  = concept.cloud-provider-authorization
    via = source.iam_role_id
  }

  relation "uses-cloud-authorization" {
    to  = concept.cloud-provider-authorization
    via = source.role_id
  }
}

rule "backup-compliance-policy" {
  match {
    type = "mongodbatlas_backup_compliance_policy"
  }

  as = concept.backup-configuration

  contribution {
    to  = concept.project
    via = source.project_id
  }
}
