rule "cognito-user-group" {
  match {
    type = "aws_cognito_user_group"
  }

  as = concept.cognito-component

  contribution {
    to  = concept.cognito-user-pool
    via = source.user_pool_id
  }
}

rule "cognito-user-pool-domain" {
  match {
    type = "aws_cognito_user_pool_domain"
  }

  as = concept.cognito-component

  contribution {
    to  = concept.cognito-user-pool
    via = source.user_pool_id
  }
}
