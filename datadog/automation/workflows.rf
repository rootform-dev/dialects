concept "automation-workflow" {
  description = "A Datadog workflow coordinating operational actions across integrations."
}

rule "workflow-automation" {
  match {
    type = "datadog_workflow_automation"
  }

  as = concept.automation-workflow
}

rule "workflow-automation-lookup" {
  match {
    kind = "data"
    type = "datadog_workflow_automation"
  }

  as = concept.automation-workflow
}
