concept "vault-dedicated-cluster" {
  description = "A HashiCorp-managed Vault Dedicated cluster on HCP."
}

concept "vault-plugin" {
  description = "A custom plugin installed into an HCP Vault Dedicated cluster."
}

rule "vault-cluster" {
  match {
    type = "hcp_vault_cluster"
  }

  as = concept.vault-dedicated-cluster

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "replicates-from" {
    to  = concept.vault-dedicated-cluster
    via = source.primary_link
  }
}

rule "vault-cluster-lookup" {
  match {
    kind = "data"
    type = "hcp_vault_cluster"
  }

  as = concept.vault-dedicated-cluster

  context {
    as  = rf.context.network
    to  = rf.concept.virtual-network
    via = source.hvn_id
  }

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "replicates-from" {
    to  = concept.vault-dedicated-cluster
    via = source.primary_link
  }
}

rule "vault-plugin" {
  match {
    type = "hcp_vault_plugin"
  }

  as = concept.vault-plugin

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "extends-cluster" {
    to  = concept.vault-dedicated-cluster
    via = source.cluster_id
  }
}

rule "vault-plugin-lookup" {
  match {
    kind = "data"
    type = "hcp_vault_plugin"
  }

  as = concept.vault-plugin

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }

  relation "extends-cluster" {
    to  = concept.vault-dedicated-cluster
    via = source.cluster_id
  }
}
