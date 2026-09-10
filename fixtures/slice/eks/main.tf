terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.62.0"
    }
  }
}

resource "aws_eks_cluster" "workloads" {
  name = "workloads"
}

resource "aws_eks_node_group" "system" {
  cluster_name = aws_eks_cluster.workloads.name
}

resource "aws_eks_fargate_profile" "jobs" {
  cluster_name = aws_eks_cluster.workloads.name
}
