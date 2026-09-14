# Maintained directly from pinned provider evidence.




concept "entra-application" {
  description = "A Microsoft Entra application identity definition."
}

concept "entra-directory" {
  description = "A Microsoft Entra External ID directory boundary."
}

concept "entra-domain-service" {
  description = "A Microsoft Entra Domain Services managed domain."
}

concept "identity-governance-detail" {
  description = "A location, assignment, federation, role, or policy supporting identity governance."
}



rule "entra-access-package-assignment-policy" {
  match {
    type = "azuread_access_package_assignment_policy"
  }

  as = concept.identity-governance-detail
}



rule "entra-app-role-assignment" {
  match {
    type = "azuread_app_role_assignment"
  }

  as = concept.identity-governance-detail
}

rule "entra-application" {
  match {
    type = "azuread_application"
  }

  as = concept.entra-application
}

rule "entra-application-federated-identity" {
  match {
    type = "azuread_application_federated_identity_credential"
  }

  as = concept.identity-governance-detail
}

rule "entra-application-registration" {
  match {
    type = "azuread_application_registration"
  }

  as = concept.entra-application
}

rule "entra-authentication-strength-policy" {
  match {
    type = "azuread_authentication_strength_policy"
  }

  as = concept.identity-governance-detail
}


rule "entra-domain-services" {
  match {
    type = "azurerm_active_directory_domain_service"
  }

  as = concept.entra-domain-service

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "entra-domain-services-replica-set" {
  match {
    type = "azurerm_active_directory_domain_service_replica_set"
  }

  as = concept.identity-governance-detail
}

rule "entra-domain-services-trust" {
  match {
    type = "azurerm_active_directory_domain_service_trust"
  }

  as = concept.identity-governance-detail
}

rule "entra-external-id-directory" {
  match {
    type = "azurerm_aadb2c_directory"
  }

  as = concept.entra-directory

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}

rule "entra-group" {
  match {
    type = "azuread_group"
  }

  as = concept.identity-group
}

rule "entra-group-without-members" {
  match {
    type = "azuread_group_without_members"
  }

  as = concept.identity-group
}

rule "entra-named-location" {
  match {
    type = "azuread_named_location"
  }

  as = concept.identity-governance-detail
}

rule "entra-service-principal" {
  match {
    type = "azuread_service_principal"
  }

  as = rf.concept.service-identity
}
