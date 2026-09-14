
concept "identity-access-configuration" {
  description = "A membership, role, assignment, entitlement, permission, or federation configuration in Databricks."
}

rule "identity-group" {
  match {
    type = "databricks_group"
  }

  as = concept.identity-group
}

rule "account-identity-group" {
  match {
    type = "databricks_account_iam_group_v2"
  }

  as = concept.identity-group
}

rule "workspace-identity-group" {
  match {
    type = "databricks_workspace_iam_group_v2"
  }

  as = concept.identity-group
}

rule "service-principal" {
  match {
    type = "databricks_service_principal"
  }

  as = rf.concept.service-identity
}

rule "account-service-principal" {
  match {
    type = "databricks_account_iam_service_principal_v2"
  }

  as = rf.concept.service-identity
}

rule "workspace-service-principal" {
  match {
    type = "databricks_workspace_iam_service_principal_v2"
  }

  as = rf.concept.service-identity
}


rule "account-federation-policy" {
  match {
    type = "databricks_account_federation_policy"
  }

  as = concept.identity-access-configuration
}

rule "service-principal-federation-policy" {
  match {
    type = "databricks_service_principal_federation_policy"
  }

  as = concept.identity-access-configuration
}

rule "group-member" {
  match {
    type = "databricks_group_member"
  }

  as = concept.identity-access-configuration
}

rule "group-role" {
  match {
    type = "databricks_group_role"
  }

  as = concept.identity-access-configuration
}

rule "group-instance-profile" {
  match {
    type = "databricks_group_instance_profile"
  }

  as = concept.identity-access-configuration
}

rule "service-principal-role" {
  match {
    type = "databricks_service_principal_role"
  }

  as = concept.identity-access-configuration
}

rule "user-role" {
  match {
    type = "databricks_user_role"
  }

  as = concept.identity-access-configuration
}

rule "user-instance-profile" {
  match {
    type = "databricks_user_instance_profile"
  }

  as = concept.identity-access-configuration
}

rule "entitlements" {
  match {
    type = "databricks_entitlements"
  }

  as = concept.identity-access-configuration
}

rule "permissions" {
  match {
    type = "databricks_permissions"
  }

  as = concept.identity-access-configuration
}

rule "permission-assignment" {
  match {
    type = "databricks_permission_assignment"
  }

  as = concept.identity-access-configuration
}

rule "mws-permission-assignment" {
  match {
    type = "databricks_mws_permission_assignment"
  }

  as = concept.identity-access-configuration
}

rule "grant" {
  match {
    type = "databricks_grant"
  }

  as = concept.identity-access-configuration
}

rule "grants" {
  match {
    type = "databricks_grants"
  }

  as = concept.identity-access-configuration
}

rule "access-control-rule-set" {
  match {
    type = "databricks_access_control_rule_set"
  }

  as = concept.identity-access-configuration
}

rule "account-group-member" {
  match {
    type = "databricks_account_iam_direct_group_member_v2"
  }

  as = concept.identity-access-configuration
}

rule "workspace-group-member" {
  match {
    type = "databricks_workspace_iam_direct_group_member_v2"
  }

  as = concept.identity-access-configuration
}

rule "account-workspace-assignment" {
  match {
    type = "databricks_account_iam_workspace_assignment_v2"
  }

  as = concept.identity-access-configuration
}

rule "workspace-identity-assignment" {
  match {
    type = "databricks_workspace_iam_workspace_assignment_v2"
  }

  as = concept.identity-access-configuration
}

rule "workspace-identity-detail" {
  match {
    type = "databricks_workspace_iam_workspace_identity_detail_v2"
  }

  as = concept.identity-access-configuration
}

rule "rfa-access-request-destinations" {
  match {
    type = "databricks_rfa_access_request_destinations"
  }

  as = concept.identity-access-configuration
}
