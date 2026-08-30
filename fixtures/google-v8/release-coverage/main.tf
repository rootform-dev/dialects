terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "= 8.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "= 8.0.0"
    }
  }
}

resource "google_dialogflow_cx_agent" "support" {}
resource "google_apigee_instance" "runtime" {}
resource "google_workflows_workflow" "orchestration" {}
resource "google_vmwareengine_private_cloud" "private_cloud" {}
resource "google_database_migration_service_migration_job" "migration" {}
resource "google_compute_disk" "data" {}
resource "google_redis_instance" "cache" {}
resource "google_backup_dr_backup_vault" "recovery" {}
resource "google_logging_project_sink" "audit" {}
resource "google_compute_firewall" "ingress" {}
resource "google_cloudbuild_worker_pool" "build" {}
resource "google_healthcare_dataset" "clinical" {}
resource "google_filestore_instance" "shared" {}
resource "google_network_connectivity_hub" "hub" {}
resource "google_vertex_ai_endpoint" "inference" {}
resource "google_spanner_instance" "database" {}
resource "google_ces_app" "customer_experience" {}
resource "google_ces_agent" "support_agent" {}
resource "google_agent_registry_service" "agent_catalog" {}
resource "google_colab_runtime" "notebook" {}
resource "google_network_services_agent_gateway" "agents" {}
resource "google_network_services_multicast_domain" "streaming" {}
resource "google_network_services_multicast_domain_group" "streaming_ha" {}
resource "google_gke_backup_restore_plan" "cluster_recovery" {}
resource "google_data_loss_prevention_discovery_config" "sensitive_data" {}
resource "google_model_armor_template" "ai_guardrail" {}
resource "google_cloud_security_compliance_framework" "compliance" {}
resource "google_migration_center_source" "discovery" {}
resource "google_os_config_patch_deployment" "patching" {}
resource "google_privileged_access_manager_entitlement" "elevated_access" {}
resource "google_security_scanner_scan_config" "web_scan" {}
