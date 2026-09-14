rule "db-instance" {
  match {
    type = "aws_db_instance"
  }

  as = rf.concept.managed-database
}

rule "rds-cluster" {
  match {
    type = "aws_rds_cluster"
  }

  as = rf.concept.managed-database
}

rule "rds-cluster-instance" {
  match {
    type = "aws_rds_cluster_instance"
  }

  as = concept.managed-database-component

  contribution {
    to  = rf.concept.managed-database
    via = source.cluster_identifier
  }
}

rule "docdb-cluster-instance" {
  match {
    type = "aws_docdb_cluster_instance"
  }

  as = concept.managed-database-component

  contribution {
    to  = rf.concept.managed-database
    via = source.cluster_identifier
  }
}

rule "neptune-cluster-instance" {
  match {
    type = "aws_neptune_cluster_instance"
  }

  as = concept.managed-database-component

  contribution {
    to  = rf.concept.managed-database
    via = source.cluster_identifier
  }
}

rule "rds-cluster-endpoint" {
  match {
    type = "aws_rds_cluster_endpoint"
  }

  as = concept.managed-database-component

  contribution {
    to  = rf.concept.managed-database
    via = source.cluster_identifier
  }
}

rule "rds-cluster-activity-stream" {
  match {
    type = "aws_rds_cluster_activity_stream"
  }

  as = concept.managed-database-component

  contribution {
    to  = rf.concept.managed-database
    via = source.resource_arn
  }
}

rule "db-proxy-default-target-group" {
  match {
    type = "aws_db_proxy_default_target_group"
  }

  as = concept.db-proxy-component

  contribution {
    to  = concept.db-proxy
    via = source.db_proxy_name
  }
}

rule "db-proxy-endpoint" {
  match {
    type = "aws_db_proxy_endpoint"
  }

  as = concept.db-proxy-component

  contribution {
    to  = concept.db-proxy
    via = source.db_proxy_name
  }
}
