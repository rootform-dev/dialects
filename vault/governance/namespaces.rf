concept "governance-configuration" {
  description = "A policy, quota, or administrative object supporting Vault governance."
}

concept "namespace" {
  description = "An isolated Vault tenancy boundary for secrets, auth methods, identities, and policies."
}

rule "config-control-group" {
  match {
    type = "vault_config_control_group"
  }

  as = concept.governance-configuration
}

rule "config-group-policy-application" {
  match {
    type = "vault_config_group_policy_application"
  }

  as = concept.governance-configuration
}

rule "egp-policy" {
  match {
    type = "vault_egp_policy"
  }

  as = concept.governance-configuration
}

rule "namespace" {
  match {
    type = "vault_namespace"
  }

  as = concept.namespace

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}

rule "password-policy" {
  match {
    type = "vault_password_policy"
  }

  as = concept.governance-configuration
}

rule "policy" {
  match {
    type = "vault_policy"
  }

  as = concept.governance-configuration
}

rule "rgp-policy" {
  match {
    type = "vault_rgp_policy"
  }

  as = concept.governance-configuration
}

rule "rotation-policy" {
  match {
    type = "vault_rotation_policy"
  }

  as = concept.governance-configuration
}
