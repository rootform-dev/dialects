terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "= 5.3.0" }
  }
}

variable "unknown_id" { type = string }

# One declaration per azurerm rule whose resource_group_name reference yields core/ownership.

resource "azurerm_resource_group" "platform" {
  name     = "platform"
  location = "West Europe"
}

# ai-ml
resource "azurerm_ai_foundry" "owned" {
  name                = "ai-foundry"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_bot_channels_registration" "owned" {
  name                = "bot-channels-registration"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_bot_service_azure_bot" "owned" {
  name                = "bot-service-azure-bot"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_bot_web_app" "owned" {
  name                = "bot-web-app"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_cognitive_account" "owned" {
  name                = "cognitive-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_healthbot" "owned" {
  name                = "healthbot"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_machine_learning_workspace" "owned" {
  name                = "machine-learning-workspace"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_search_service" "owned" {
  name                = "search-service"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_video_indexer_account" "owned" {
  name                = "video-indexer-account"
  resource_group_name = azurerm_resource_group.platform.name
}

# api-integration
resource "azurerm_api_management" "owned" {
  name                = "api-management"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_api_management_standalone_gateway" "owned" {
  name                = "api-management-standalone-gateway"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_app_configuration" "owned" {
  name                = "app-configuration"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_logic_app_integration_account" "owned" {
  name                = "logic-app-integration-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_logic_app_standard" "owned" {
  name                = "logic-app-standard"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_logic_app_workflow" "owned" {
  name                = "logic-app-workflow"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_maps_account" "owned" {
  name                = "maps-account"
  resource_group_name = azurerm_resource_group.platform.name
}

# communication
resource "azurerm_communication_service" "owned" {
  name                = "communication-service"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_email_communication_service" "owned" {
  name                = "email-communication-service"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_fluid_relay_server" "owned" {
  name                = "fluid-relay-server"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_signalr_service" "owned" {
  name                = "signalr-service"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_web_pubsub" "owned" {
  name                = "web-pubsub"
  resource_group_name = azurerm_resource_group.platform.name
}

# compute
resource "azurerm_batch_account" "owned" {
  name                = "batch-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_dedicated_host_group" "owned" {
  name                = "dedicated-host-group"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_dev_test_linux_virtual_machine" "owned" {
  name                = "dev-test-linux-virtual-machine"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_dev_test_windows_virtual_machine" "owned" {
  name                = "dev-test-windows-virtual-machine"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_image" "owned" {
  name                = "image"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_managed_disk" "owned" {
  name                = "managed-disk"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_shared_image" "owned" {
  name                = "shared-image"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_snapshot" "owned" {
  name                = "snapshot"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_stack_hci_virtual_hard_disk" "owned" {
  name                = "stack-hci-virtual-hard-disk"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_virtual_desktop_application_group" "owned" {
  name                = "virtual-desktop-application-group"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_virtual_desktop_host_pool" "owned" {
  name                = "virtual-desktop-host-pool"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_virtual_desktop_workspace" "owned" {
  name                = "virtual-desktop-workspace"
  resource_group_name = azurerm_resource_group.platform.name
}

# containers
resource "azurerm_arc_kubernetes_cluster" "owned" {
  name                = "arc-kubernetes-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_arc_kubernetes_provisioned_cluster" "owned" {
  name                = "arc-kubernetes-provisioned-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_container_group" "owned" {
  name                = "container-group"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_container_registry" "owned" {
  name                = "container-registry"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_kubernetes_automatic_cluster" "owned" {
  name                = "kubernetes-automatic-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_kubernetes_fleet_manager" "owned" {
  name                = "kubernetes-fleet-manager"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_redhat_openshift_cluster" "owned" {
  name                = "redhat-openshift-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_service_fabric_cluster" "owned" {
  name                = "service-fabric-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_service_fabric_managed_cluster" "owned" {
  name                = "service-fabric-managed-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}

# data-analytics
resource "azurerm_analysis_services_server" "owned" {
  name                = "analysis-services-server"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_data_factory" "owned" {
  name                = "data-factory"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_data_share_account" "owned" {
  name                = "data-share-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_databricks_workspace" "owned" {
  name                = "databricks-workspace"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_fabric_capacity" "owned" {
  name                = "fabric-capacity"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_graph_services_account" "owned" {
  name                = "graph-services-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_hdinsight_hadoop_cluster" "owned" {
  name                = "hdinsight-hadoop-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_hdinsight_hbase_cluster" "owned" {
  name                = "hdinsight-hbase-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_hdinsight_interactive_query_cluster" "owned" {
  name                = "hdinsight-interactive-query-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_hdinsight_kafka_cluster" "owned" {
  name                = "hdinsight-kafka-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_hdinsight_spark_cluster" "owned" {
  name                = "hdinsight-spark-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_healthcare_fhir_service" "owned" {
  name                = "healthcare-fhir-service"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_healthcare_service" "owned" {
  name                = "healthcare-service"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_healthcare_workspace" "owned" {
  name                = "healthcare-workspace"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_powerbi_embedded" "owned" {
  name                = "powerbi-embedded"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_purview_account" "owned" {
  name                = "purview-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_stream_analytics_cluster" "owned" {
  name                = "stream-analytics-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_stream_analytics_job" "owned" {
  name                = "stream-analytics-job"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_synapse_workspace" "owned" {
  name                = "synapse-workspace"
  resource_group_name = azurerm_resource_group.platform.name
}

# databases
resource "azurerm_cosmosdb_account" "owned" {
  name                = "cosmosdb-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_cosmosdb_cassandra_cluster" "owned" {
  name                = "cosmosdb-cassandra-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_cosmosdb_postgresql_cluster" "owned" {
  name                = "cosmosdb-postgresql-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_kusto_cluster" "owned" {
  name                = "kusto-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_managed_redis" "owned" {
  name                = "managed-redis"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_mongo_cluster" "owned" {
  name                = "mongo-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_mssql_managed_instance" "owned" {
  name                = "mssql-managed-instance"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_mysql_flexible_database" "owned" {
  name                = "mysql-flexible-database"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_mysql_flexible_server" "owned" {
  name                = "mysql-flexible-server"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_oracle_autonomous_database" "owned" {
  name                = "oracle-autonomous-database"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_redis_cache" "owned" {
  name                = "redis-cache"
  resource_group_name = azurerm_resource_group.platform.name
}

# developer-ci-cd
resource "azurerm_dev_center" "owned" {
  name                = "dev-center"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_dev_center_project" "owned" {
  name                = "dev-center-project"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_dev_test_lab" "owned" {
  name                = "dev-test-lab"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_managed_devops_pool" "owned" {
  name                = "managed-devops-pool"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_playwright_workspace" "owned" {
  name                = "playwright-workspace"
  resource_group_name = azurerm_resource_group.platform.name
}

# dns-cdn
resource "azurerm_cdn_endpoint" "owned" {
  name                = "cdn-endpoint"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_cdn_profile" "owned" {
  name                = "cdn-profile"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_dns_zone" "owned" {
  name                = "dns-zone"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_private_dns_resolver" "owned" {
  name                = "private-dns-resolver"
  resource_group_name = azurerm_resource_group.platform.name
}

# governance-management
resource "azurerm_managed_application" "owned" {
  name                = "managed-application"
  resource_group_name = azurerm_resource_group.platform.name
}

# hybrid
resource "azurerm_arc_machine" "owned" {
  name                = "arc-machine"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_arc_resource_bridge_appliance" "owned" {
  name                = "arc-resource-bridge-appliance"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_extended_location_custom_location" "owned" {
  name                = "extended-location-custom-location"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_nginx_deployment" "owned" {
  name                = "nginx-deployment"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_oracle_cloud_vm_cluster" "owned" {
  name                = "oracle-cloud-vm-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_oracle_exadata_infrastructure" "owned" {
  name                = "oracle-exadata-infrastructure"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_oracle_resource_anchor" "owned" {
  name                = "oracle-resource-anchor"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_palo_alto_next_generation_firewall_virtual_network_local_rulestack" "owned" {
  name                = "palo-alto-next-generation-firewall-virtu"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_stack_hci_cluster" "owned" {
  name                = "stack-hci-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_system_center_virtual_machine_manager_server" "owned" {
  name                = "system-center-virtual-machine-manager-se"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_vmware_private_cloud" "owned" {
  name                = "vmware-private-cloud"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_workloads_sap_discovery_virtual_instance" "owned" {
  name                = "workloads-sap-discovery-virtual-instance"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_workloads_sap_single_node_virtual_instance" "owned" {
  name                = "workloads-sap-single-node-virtual-instan"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_workloads_sap_three_tier_virtual_instance" "owned" {
  name                = "workloads-sap-three-tier-virtual-instanc"
  resource_group_name = azurerm_resource_group.platform.name
}

# identity-iam
resource "azurerm_aadb2c_directory" "owned" {
  name                = "aadb2c-directory"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_active_directory_domain_service" "owned" {
  name                = "active-directory-domain-service"
  resource_group_name = azurerm_resource_group.platform.name
}

# iot
resource "azurerm_digital_twins_instance" "owned" {
  name                = "digital-twins-instance"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_iotcentral_application" "owned" {
  name                = "iotcentral-application"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_iothub" "owned" {
  name                = "iothub"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_iothub_device_update_account" "owned" {
  name                = "iothub-device-update-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_iothub_dps" "owned" {
  name                = "iothub-dps"
  resource_group_name = azurerm_resource_group.platform.name
}

# load-balancing
resource "azurerm_application_load_balancer" "owned" {
  name                = "application-load-balancer"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_cdn_frontdoor_profile" "owned" {
  name                = "cdn-frontdoor-profile"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_frontdoor" "owned" {
  name                = "frontdoor"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_traffic_manager_profile" "owned" {
  name                = "traffic-manager-profile"
  resource_group_name = azurerm_resource_group.platform.name
}

# messaging-eventing
resource "azurerm_eventgrid_domain" "owned" {
  name                = "eventgrid-domain"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_eventgrid_namespace" "owned" {
  name                = "eventgrid-namespace"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_eventgrid_partner_namespace" "owned" {
  name                = "eventgrid-partner-namespace"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_eventgrid_system_topic" "owned" {
  name                = "eventgrid-system-topic"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_eventgrid_system_topic_event_subscription" "owned" {
  name                = "eventgrid-system-topic-event-subscriptio"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_eventgrid_topic" "owned" {
  name                = "eventgrid-topic"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_eventhub_cluster" "owned" {
  name                = "eventhub-cluster"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_eventhub_namespace" "owned" {
  name                = "eventhub-namespace"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_notification_hub" "owned" {
  name                = "notification-hub"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_notification_hub_namespace" "owned" {
  name                = "notification-hub-namespace"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_relay_hybrid_connection" "owned" {
  name                = "relay-hybrid-connection"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_relay_namespace" "owned" {
  name                = "relay-namespace"
  resource_group_name = azurerm_resource_group.platform.name
}

# migration
resource "azurerm_backup_policy_file_share" "owned" {
  name                = "backup-policy-file-share"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_backup_policy_vm" "owned" {
  name                = "backup-policy-vm"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_database_migration_project" "owned" {
  name                = "database-migration-project"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_database_migration_service" "owned" {
  name                = "database-migration-service"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_databox_edge_device" "owned" {
  name                = "databox-edge-device"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_recovery_services_vault" "owned" {
  name                = "recovery-services-vault"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_site_recovery_fabric" "owned" {
  name                = "site-recovery-fabric"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_site_recovery_protection_container" "owned" {
  name                = "site-recovery-protection-container"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_storage_mover" "owned" {
  name                = "storage-mover"
  resource_group_name = azurerm_resource_group.platform.name
}

# network
resource "azurerm_arc_private_link_scope" "owned" {
  name                = "arc-private-link-scope"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_bastion_host" "owned" {
  name                = "bastion-host"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_custom_ip_prefix" "owned" {
  name                = "custom-ip-prefix"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_databricks_virtual_network_peering" "owned" {
  name                = "databricks-virtual-network-peering"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_express_route_circuit" "owned" {
  name                = "express-route-circuit"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_express_route_gateway" "owned" {
  name                = "express-route-gateway"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_express_route_port" "owned" {
  name                = "express-route-port"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_firewall" "owned" {
  name                = "firewall"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_local_network_gateway" "owned" {
  name                = "local-network-gateway"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_monitor_private_link_scope" "owned" {
  name                = "monitor-private-link-scope"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_nat_gateway" "owned" {
  name                = "nat-gateway"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_network_ddos_protection_plan" "owned" {
  name                = "network-ddos-protection-plan"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_network_function_azure_traffic_collector" "owned" {
  name                = "network-function-azure-traffic-collector"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_network_manager" "owned" {
  name                = "network-manager"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_network_security_group" "owned" {
  name                = "network-security-group"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_network_security_perimeter" "owned" {
  name                = "network-security-perimeter"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_point_to_site_vpn_gateway" "owned" {
  name                = "point-to-site-vpn-gateway"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_private_link_service" "owned" {
  name                = "private-link-service"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_public_ip_prefix" "owned" {
  name                = "public-ip-prefix"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_route_server" "owned" {
  name                = "route-server"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_route_table" "owned" {
  name                = "route-table"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_synapse_private_link_hub" "owned" {
  name                = "synapse-private-link-hub"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_virtual_hub" "owned" {
  name                = "virtual-hub"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_virtual_network_gateway" "owned" {
  name                = "virtual-network-gateway"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_virtual_network_gateway_connection" "owned" {
  name                = "virtual-network-gateway-connection"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_virtual_network_peering" "owned" {
  name                = "virtual-network-peering"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_virtual_wan" "owned" {
  name                = "virtual-wan"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_vpn_gateway" "owned" {
  name                = "vpn-gateway"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_vpn_site" "owned" {
  name                = "vpn-site"
  resource_group_name = azurerm_resource_group.platform.name
}

# operations
resource "azurerm_automation_account" "owned" {
  name                = "automation-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_automation_runbook" "owned" {
  name                = "automation-runbook"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_chaos_studio_experiment" "owned" {
  name                = "chaos-studio-experiment"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_dashboard_grafana" "owned" {
  name                = "dashboard-grafana"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_datadog_monitor" "owned" {
  name                = "datadog-monitor"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_dynatrace_monitor" "owned" {
  name                = "dynatrace-monitor"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_elastic_cloud_elasticsearch" "owned" {
  name                = "elastic-cloud-elasticsearch"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_load_test" "owned" {
  name                = "load-test"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_maintenance_configuration" "owned" {
  name                = "maintenance-configuration"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_network_watcher" "owned" {
  name                = "network-watcher"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_new_relic_monitor" "owned" {
  name                = "new-relic-monitor"
  resource_group_name = azurerm_resource_group.platform.name
}

# security
resource "azurerm_attestation_provider" "owned" {
  name                = "attestation-provider"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_confidential_ledger" "owned" {
  name                = "confidential-ledger"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_dedicated_hardware_security_module" "owned" {
  name                = "dedicated-hardware-security-module"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_key_vault" "owned" {
  name                = "key-vault"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_key_vault_managed_hardware_security_module" "owned" {
  name                = "key-vault-managed-hardware-security-modu"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_trusted_signing_account" "owned" {
  name                = "trusted-signing-account"
  resource_group_name = azurerm_resource_group.platform.name
}

# serverless
resource "azurerm_spring_cloud_app" "owned" {
  name                = "spring-cloud-app"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_spring_cloud_service" "owned" {
  name                = "spring-cloud-service"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_static_web_app" "owned" {
  name                = "static-web-app"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_windows_function_app" "owned" {
  name                = "windows-function-app"
  resource_group_name = azurerm_resource_group.platform.name
}

# storage
resource "azurerm_data_protection_backup_vault" "owned" {
  name                = "data-protection-backup-vault"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_elastic_san" "owned" {
  name                = "elastic-san"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_managed_lustre_file_system" "owned" {
  name                = "managed-lustre-file-system"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_netapp_account" "owned" {
  name                = "netapp-account"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_netapp_backup_policy" "owned" {
  name                = "netapp-backup-policy"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_netapp_backup_vault" "owned" {
  name                = "netapp-backup-vault"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_netapp_pool" "owned" {
  name                = "netapp-pool"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_netapp_volume" "owned" {
  name                = "netapp-volume"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_qumulo_file_system" "owned" {
  name                = "qumulo-file-system"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_shared_image_gallery" "owned" {
  name                = "shared-image-gallery"
  resource_group_name = azurerm_resource_group.platform.name
}
resource "azurerm_storage_sync" "owned" {
  name                = "storage-sync"
  resource_group_name = azurerm_resource_group.platform.name
}

# literal and unknown resource group names produce no ownership context
resource "azurerm_container_registry" "literal" {
  name                = "rootformliteral"
  resource_group_name = "platform"
}

resource "azurerm_redis_cache" "unknown" {
  name                = "unknown"
  resource_group_name = var.unknown_id
}
