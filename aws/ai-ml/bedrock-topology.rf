rule "bedrockagent-agent-action-group" {
  match {
    type = "aws_bedrockagent_agent_action_group"
  }

  as = concept.bedrock-agent-component

  contribution {
    to  = concept.bedrockagent-agent
    via = source.agent_id
  }
}
