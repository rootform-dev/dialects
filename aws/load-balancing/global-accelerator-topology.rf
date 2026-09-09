rule "globalaccelerator-accelerator" {
  match {
    type = "aws_globalaccelerator_accelerator"
  }

  as = concept.global-accelerator
}

rule "globalaccelerator-listener" {
  match {
    type = "aws_globalaccelerator_listener"
  }

  as = concept.global-accelerator-component

  contribution {
    to  = concept.global-accelerator
    via = source.accelerator_arn
  }
}

rule "globalaccelerator-endpoint-group" {
  match {
    type = "aws_globalaccelerator_endpoint_group"
  }

  as = concept.global-accelerator-component
}

rule "globalaccelerator-custom-routing-accelerator" {
  match {
    type = "aws_globalaccelerator_custom_routing_accelerator"
  }

  as = concept.global-accelerator
}

rule "globalaccelerator-custom-routing-listener" {
  match {
    type = "aws_globalaccelerator_custom_routing_listener"
  }

  as = concept.global-accelerator-component

  contribution {
    to  = concept.global-accelerator
    via = source.accelerator_arn
  }
}

rule "globalaccelerator-custom-routing-endpoint-group" {
  match {
    type = "aws_globalaccelerator_custom_routing_endpoint_group"
  }

  as = concept.global-accelerator-component
}
