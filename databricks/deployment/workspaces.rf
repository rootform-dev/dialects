concept "workspace" {
  description = "A Databricks workspace providing an isolated environment for data, analytics, and AI workloads."
}

concept "workspace-root-storage" {
  description = "A cloud storage registration used as root storage by Databricks workspaces."
}

concept "workspace-deployment-credential" {
  description = "A cloud identity registration used to deploy Databricks workspace resources."
}

concept "workspace-key-configuration" {
  description = "A customer-managed key registration protecting Databricks workspace data or services."
}

concept "log-delivery" {
  description = "A Databricks account or workspace log-delivery configuration."
}


concept "workspace-configuration" {
  description = "Configuration, assignment, or setting supporting a Databricks workspace."
}

rule "workspace" {
  match {
    type = "databricks_mws_workspaces"
  }

  as = concept.workspace

  relation "uses-network" {
    to  = concept.workspace-network-configuration
    via = source.network_id
  }

  relation "uses-root-storage" {
    to  = concept.workspace-root-storage
    via = source.storage_configuration_id
  }

  relation "uses-deployment-credential" {
    to  = concept.workspace-deployment-credential
    via = source.credentials_id
  }

  relation "uses-private-access" {
    to  = concept.private-access-settings
    via = source.private_access_settings_id
  }

  relation "uses-serverless-network" {
    to  = concept.network-connectivity-configuration
    via = source.network_connectivity_config_id
  }
}

rule "workspace-deployment-credential" {
  match {
    type = "databricks_mws_credentials"
  }

  as = concept.workspace-deployment-credential

}

rule "workspace-root-storage" {
  match {
    type = "databricks_mws_storage_configurations"
  }

  as = concept.workspace-root-storage

  relation "stores-in" {
    to  = rf.concept.object-storage-container
    via = source.bucket_name
  }

}

rule "workspace-customer-managed-key" {
  match {
    type = "databricks_mws_customer_managed_keys"
  }

  as = concept.workspace-key-configuration

  relation "uses-key" {
    to  = concept.encryption-key
    via = source.aws_key_info[0].key_arn
  }

  relation "uses-key" {
    to  = concept.encryption-key
    via = source.gcp_key_info[0].kms_key_id
  }
}

rule "log-delivery" {
  match {
    type = "databricks_mws_log_delivery"
  }

  as = concept.log-delivery

  relation "delivers-to" {
    to  = concept.workspace-root-storage
    via = source.storage_configuration_id
  }

  relation "uses-deployment-credential" {
    to  = concept.workspace-deployment-credential
    via = source.credentials_id
  }
}


rule "disaster-recovery-stable-url" {
  match {
    type = "databricks_disaster_recovery_stable_url"
  }

  as = concept.workspace-configuration
}

rule "workspace-configuration" {
  match {
    type = "databricks_workspace_conf"
  }

  as = concept.workspace-configuration
}

rule "workspace-setting" {
  match {
    type = "databricks_workspace_setting_v2"
  }

  as = concept.workspace-configuration
}

rule "account-setting" {
  match {
    type = "databricks_account_setting_v2"
  }

  as = concept.workspace-configuration
}

rule "workspace-network-option" {
  match {
    type = "databricks_workspace_network_option"
  }

  as = concept.workspace-configuration
}

rule "default-namespace-setting" {
  match {
    type = "databricks_default_namespace_setting"
  }

  as = concept.workspace-configuration
}

rule "disable-legacy-access-setting" {
  match {
    type = "databricks_disable_legacy_access_setting"
  }

  as = concept.workspace-configuration
}

rule "disable-legacy-dbfs-setting" {
  match {
    type = "databricks_disable_legacy_dbfs_setting"
  }

  as = concept.workspace-configuration
}

rule "disable-legacy-features-setting" {
  match {
    type = "databricks_disable_legacy_features_setting"
  }

  as = concept.workspace-configuration
}

rule "automatic-cluster-update-setting" {
  match {
    type = "databricks_automatic_cluster_update_workspace_setting"
  }

  as = concept.workspace-configuration
}

rule "compliance-security-profile-setting" {
  match {
    type = "databricks_compliance_security_profile_workspace_setting"
  }

  as = concept.workspace-configuration
}

rule "enhanced-security-monitoring-setting" {
  match {
    type = "databricks_enhanced_security_monitoring_workspace_setting"
  }

  as = concept.workspace-configuration
}

rule "restrict-workspace-admins-setting" {
  match {
    type = "databricks_restrict_workspace_admins_setting"
  }

  as = concept.workspace-configuration
}

rule "workspace-binding" {
  match {
    type = "databricks_workspace_binding"
  }

  as = concept.workspace-configuration
}

rule "warehouses-default-warehouse-override" {
  match {
    type = "databricks_warehouses_default_warehouse_override"
  }

  as = concept.workspace-configuration
}
