# Maintained directly from pinned provider evidence.
rule "automation-runbook" {
  match {
    type = "azurerm_automation_runbook"
  }

  as = concept.workflow

  context {
    as  = context.ownership
    to  = concept.resource-group
    via = source.resource_group_name
  }
}
