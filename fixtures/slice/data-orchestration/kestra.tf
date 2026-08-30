resource "kestra_namespace" "platform" {
  namespace_id = "platform"
}

resource "kestra_flow" "ingest" {
  namespace = "platform.analytics"
  flow_id   = "ingest"
  content   = "ROOTFORM_FLOW_PAYLOAD_SENTINEL"
}

resource "kestra_group" "operators" {
  name      = "operators"
  namespace = kestra_namespace.platform.id
}

resource "kestra_role" "operator" {
  name        = "operator"
  description = "Synthetic operator role"
  namespace   = kestra_namespace.platform.id
}

resource "kestra_user" "automation" {
  email  = "automation@example.invalid"
  groups = [kestra_group.operators.id]
}

resource "kestra_binding" "operators" {
  type        = "GROUP"
  external_id = kestra_group.operators.id
  role_id     = kestra_role.operator.id
}

resource "kestra_namespace_secret" "runtime" {
  namespace    = kestra_namespace.platform.id
  secret_key   = "RUNTIME_TOKEN"
  secret_value = data.vault_generic_secret.runtime.data["token"]
}

resource "kestra_user_password" "automation" {
  user_id  = kestra_user.automation.id
  password = random_password.automation.result
}
