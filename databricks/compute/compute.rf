concept "compute-cluster" {
  description = "A Databricks compute cluster running data, analytics, or machine-learning workloads."
}

concept "instance-pool" {
  description = "A shared pool of cloud instances used to reduce Databricks cluster start time."
}

concept "compute-configuration" {
  description = "A policy, library, environment, identity registration, or setting supporting Databricks compute."
}

rule "compute-cluster" {
  match {
    type = "databricks_cluster"
  }

  as = concept.compute-cluster

  relation "uses-pool" {
    to  = concept.instance-pool
    via = source.instance_pool_id
  }

  relation "uses-driver-pool" {
    to  = concept.instance-pool
    via = source.driver_instance_pool_id
  }

  relation "uses-cloud-identity" {
    to  = rf.concept.service-identity
    via = source.gcp_attributes[0].google_service_account
  }
}

rule "instance-pool" {
  match {
    type = "databricks_instance_pool"
  }

  as = concept.instance-pool

}

rule "cluster-policy" {
  match {
    type = "databricks_cluster_policy"
  }

  as = concept.compute-configuration
}

rule "policy-info" {
  match {
    type = "databricks_policy_info"
  }

  as = concept.compute-configuration
}

rule "instance-profile" {
  match {
    type = "databricks_instance_profile"
  }

  as = concept.compute-configuration
}

rule "cluster-library" {
  match {
    type = "databricks_library"
  }

  as = concept.compute-configuration

  contribution {
    to  = concept.compute-cluster
    via = source.cluster_id
  }
}

rule "artifact-allowlist" {
  match {
    type = "databricks_artifact_allowlist"
  }

  as = concept.compute-configuration
}

rule "global-init-script" {
  match {
    type = "databricks_global_init_script"
  }

  as = concept.compute-configuration
}

rule "workspace-base-environment" {
  match {
    type = "databricks_environments_workspace_base_environment"
  }

  as = concept.compute-configuration
}

rule "default-workspace-base-environment" {
  match {
    type = "databricks_environments_default_workspace_base_environment"
  }

  as = concept.compute-configuration
}
