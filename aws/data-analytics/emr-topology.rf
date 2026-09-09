rule "emr-instance-fleet" {
  match {
    type = "aws_emr_instance_fleet"
  }

  as = concept.emr-cluster-component

  contribution {
    to  = concept.emr-cluster
    via = source.cluster_id
  }
}

rule "emr-instance-group" {
  match {
    type = "aws_emr_instance_group"
  }

  as = concept.emr-cluster-component

  contribution {
    to  = concept.emr-cluster
    via = source.cluster_id
  }
}
