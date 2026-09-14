rule "eks-cluster" {
  match {
    type = "aws_eks_cluster"
  }

  as = rf.concept.kubernetes-cluster
}

rule "eks-node-group" {
  match {
    type = "aws_eks_node_group"
  }

  as = concept.kubernetes-node-pool

  contribution {
    to  = rf.concept.kubernetes-cluster
    via = source.cluster_name

    match {
      by       = target.name
      strategy = "exact"
    }
  }
}

rule "eks-fargate-profile" {
  match {
    type = "aws_eks_fargate_profile"
  }

  as = concept.eks-compute-profile

  contribution {
    to  = rf.concept.kubernetes-cluster
    via = source.cluster_name

    match {
      by       = target.name
      strategy = "exact"
    }
  }
}

rule "ecs-cluster" {
  match {
    type = "aws_ecs_cluster"
  }

  as = concept.ecs-cluster
}

rule "ecs-service" {
  match {
    type = "aws_ecs_service"
  }

  as = concept.ecs-service

  context {
    as  = rf.context.runtime
    to  = concept.ecs-cluster
    via = source.cluster
  }
}
