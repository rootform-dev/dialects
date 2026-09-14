concept "audit-device" {
  description = "A Vault audit device receiving security audit records."
}

concept "operations-configuration" {
  description = "An audit, Raft, or continuity setting supporting Vault operations."
}

concept "vault-agent" {
  description = "A registered Vault Agent workload identity boundary."
}

rule "agent-registration" {
  match {
    type = "vault_agent_registration"
  }

  as = concept.vault-agent

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "audit" {
  match {
    type = "vault_audit"
  }

  as = concept.audit-device

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "audit-request-header" {
  match {
    type = "vault_audit_request_header"
  }

  as = concept.operations-configuration
}

rule "raft-autopilot" {
  match {
    type = "vault_raft_autopilot"
  }

  as = concept.operations-configuration
}

rule "raft-snapshot-agent-config" {
  match {
    type = "vault_raft_snapshot_agent_config"
  }

  as = concept.backup-plan

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }

  relation "stores-snapshots-in" {
    to  = rf.concept.object-storage-container
    via = source.aws_s3_bucket
  }

  relation "stores-snapshots-in" {
    to  = rf.concept.object-storage-container
    via = source.azure_container_name
  }

  relation "stores-snapshots-in" {
    to  = rf.concept.object-storage-container
    via = source.google_gcs_bucket
  }

  relation "uses-encryption-key" {
    to  = concept.encryption-key
    via = source.aws_s3_kms_key
  }
}
