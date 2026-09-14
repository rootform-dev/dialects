concept "database-configuration" {
  description = "A configuration supporting MongoDB Atlas database deployments within a project."
}

rule "advanced-cluster" {
  match {
    type = "mongodbatlas_advanced_cluster"
  }

  as = rf.concept.managed-database

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "cluster" {
  match {
    type = "mongodbatlas_cluster"
  }

  as = rf.concept.managed-database

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "flex-cluster" {
  match {
    type = "mongodbatlas_flex_cluster"
  }

  as = rf.concept.managed-database

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "serverless-instance" {
  match {
    type = "mongodbatlas_serverless_instance"
  }

  as = rf.concept.managed-database

  context {
    as  = context.ownership
    to  = concept.project
    via = source.project_id
  }
}

rule "global-cluster-configuration" {
  match {
    type = "mongodbatlas_global_cluster_config"
  }

  as = concept.database-configuration

  contribution {
    to  = rf.concept.managed-database
    via = source.cluster_name
  }

  contribution {
    to  = concept.project
    via = source.project_id
  }
}

rule "maintenance-window" {
  match {
    type = "mongodbatlas_maintenance_window"
  }

  as = concept.database-configuration

  contribution {
    to  = concept.project
    via = source.project_id
  }
}
