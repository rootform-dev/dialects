rule "connect-contact-flow" {
  match {
    type = "aws_connect_contact_flow"
  }

  as = concept.connect-component

  contribution {
    to  = concept.connect-instance
    via = source.instance_id
  }
}

rule "connect-queue" {
  match {
    type = "aws_connect_queue"
  }

  as = concept.connect-component

  contribution {
    to  = concept.connect-instance
    via = source.instance_id
  }
}

rule "connect-routing-profile" {
  match {
    type = "aws_connect_routing_profile"
  }

  as = concept.connect-component

  contribution {
    to  = concept.connect-instance
    via = source.instance_id
  }
}

rule "connect-security-profile" {
  match {
    type = "aws_connect_security_profile"
  }

  as = concept.connect-component

  contribution {
    to  = concept.connect-instance
    via = source.instance_id
  }
}

rule "connect-user-hierarchy-group" {
  match {
    type = "aws_connect_user_hierarchy_group"
  }

  as = concept.connect-component

  contribution {
    to  = concept.connect-instance
    via = source.instance_id
  }
}
