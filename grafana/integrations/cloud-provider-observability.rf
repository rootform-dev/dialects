concept "cloud-integration-configuration" {
  description = "A scrape job, integration package, or plugin supporting a Grafana Cloud integration."
}

rule "cloud-integration" {
  match {
    type = "grafana_cloud_integration"
  }

  as = concept.cloud-integration-configuration
}

rule "cloud-provider-aws-account" {
  match {
    type = "grafana_cloud_provider_aws_account"
  }

  as = concept.cloud-observability-integration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }

}

rule "cloud-provider-aws-account-lookup" {
  match {
    kind = "data"
    type = "grafana_cloud_provider_aws_account"
  }

  as = concept.cloud-observability-integration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }

}

rule "cloud-provider-aws-cloudwatch-scrape-job" {
  match {
    type = "grafana_cloud_provider_aws_cloudwatch_scrape_job"
  }

  as = concept.cloud-integration-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }

  contribution {
    to  = concept.cloud-observability-integration
    via = source.aws_account_resource_id
  }
}

rule "cloud-provider-aws-cloudwatch-scrape-job-lookup" {
  match {
    kind = "data"
    type = "grafana_cloud_provider_aws_cloudwatch_scrape_job"
  }

  as = concept.cloud-integration-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }

  contribution {
    to  = concept.cloud-observability-integration
    via = source.aws_account_resource_id
  }
}

rule "cloud-provider-aws-resource-metadata-scrape-job" {
  match {
    type = "grafana_cloud_provider_aws_resource_metadata_scrape_job"
  }

  as = concept.cloud-integration-configuration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }

  contribution {
    to  = concept.cloud-observability-integration
    via = source.aws_account_resource_id
  }
}

rule "cloud-provider-azure-credential" {
  match {
    type = "grafana_cloud_provider_azure_credential"
  }

  as = concept.cloud-observability-integration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }

  relation "authorized-by" {
    to  = rf.concept.service-identity
    via = source.client_id
  }
}

rule "cloud-provider-azure-credential-lookup" {
  match {
    kind = "data"
    type = "grafana_cloud_provider_azure_credential"
  }

  as = concept.cloud-observability-integration

  context {
    as  = context.ownership
    to  = concept.observability-tenant
    via = source.stack_id
  }

  relation "authorized-by" {
    to  = rf.concept.service-identity
    via = source.client_id
  }
}
