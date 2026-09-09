rule "appsync-graphql-api" {
  match {
    type = "aws_appsync_graphql_api"
  }

  as = concept.appsync-api
}

rule "appsync-datasource" {
  match {
    type = "aws_appsync_datasource"
  }

  as = concept.appsync-component

  contribution {
    to  = concept.appsync-api
    via = source.api_id
  }
}

rule "appsync-function" {
  match {
    type = "aws_appsync_function"
  }

  as = concept.appsync-component

  contribution {
    to  = concept.appsync-api
    via = source.api_id
  }
}

rule "appsync-resolver" {
  match {
    type = "aws_appsync_resolver"
  }

  as = concept.appsync-component

  contribution {
    to  = concept.appsync-api
    via = source.api_id
  }
}
