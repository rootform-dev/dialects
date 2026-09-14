# Maintained directly from pinned provider evidence.
concept "container-app" {
  description = "An Azure Container Apps service running container revisions."
}

concept "container-app-environment" {
  description = "An Azure Container Apps environment sharing network and operational boundaries."
}

concept "container-app-job" {
  description = "An Azure Container Apps job running finite container work."
}

rule "container-app" {
  match {
    type = "azurerm_container_app"
  }

  as = concept.container-app

  context {
    as  = rf.context.runtime
    to  = concept.container-app-environment
    via = source.container_app_environment_id
  }

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "container-app-environment" {
  match {
    type = "azurerm_container_app_environment"
  }

  as = concept.container-app-environment

  context {
    as  = rf.context.network
    to  = rf.concept.subnet
    via = source.infrastructure_subnet_id
  }

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }

  relation "observed-by" {
    to  = concept.log-analytics-workspace
    via = source.log_analytics_workspace_id
  }
}

rule "container-app-job" {
  match {
    type = "azurerm_container_app_job"
  }

  as = concept.container-app-job

  context {
    as  = rf.context.runtime
    to  = concept.container-app-environment
    via = source.container_app_environment_id
  }

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
