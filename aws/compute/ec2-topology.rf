rule "instance" {
  match {
    type = "aws_instance"
  }

  as = concept.compute-instance

  context {
    as  = rf.context.network
    to  = rf.concept.subnet
    via = source.subnet_id
  }
}
