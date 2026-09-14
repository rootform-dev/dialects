concept "flow-vault-connection" {
  description = "A Forms and Flows Vault connection to an external integration."
}

rule "flow-vault-connection" {
  match {
    type = "auth0_flow_vault_connection"
  }

  as = concept.flow-vault-connection
}

rule "flow-vault-connection-lookup" {
  match {
    kind = "data"
    type = "auth0_flow_vault_connection"
  }

  as = concept.flow-vault-connection
}
