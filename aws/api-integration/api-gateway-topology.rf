rule "api-gateway-rest-api" {
  match {
    type = "aws_api_gateway_rest_api"
  }

  as = concept.api-gateway
}

rule "api-gateway-stage" {
  match {
    type = "aws_api_gateway_stage"
  }

  as = concept.api-component

  contribution {
    to  = concept.api-gateway
    via = source.rest_api_id
  }
}

rule "api-gateway-integration" {
  match {
    type = "aws_api_gateway_integration"
  }

  as = concept.api-component

  contribution {
    to  = concept.api-gateway
    via = source.rest_api_id
  }
}

rule "api-gateway-resource" {
  match {
    type = "aws_api_gateway_resource"
  }

  as = concept.api-component

  contribution {
    to  = concept.api-gateway
    via = source.rest_api_id
  }
}

rule "api-gateway-model" {
  match {
    type = "aws_api_gateway_model"
  }

  as = concept.api-component

  contribution {
    to  = concept.api-gateway
    via = source.rest_api_id
  }
}

rule "apigatewayv2-model" {
  match {
    type = "aws_apigatewayv2_model"
  }

  as = concept.api-component

  contribution {
    to  = concept.api-gateway
    via = source.api_id
  }
}
