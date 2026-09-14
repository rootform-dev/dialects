concept "organization" {
  description = "A top-level HCP ownership and governance boundary."
}

concept "project" {
  description = "An HCP boundary grouping managed products and access."
}

rule "organization-lookup" {
  match {
    kind = "data"
    type = "hcp_organization"
  }

  as = concept.organization
}

rule "project" {
  match {
    type = "hcp_project"
  }

  as = concept.project
}

rule "project-lookup" {
  match {
    kind = "data"
    type = "hcp_project"
  }

  as = concept.project
}
