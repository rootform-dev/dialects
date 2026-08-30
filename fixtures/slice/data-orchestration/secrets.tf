data "vault_generic_secret" "runtime" {
  path = "ROOTFORM_SECRET_PATH_SENTINEL"
}

resource "random_password" "automation" {
  length  = 32
  special = true
}

resource "vault_generic_secret" "managed" {
  path = "rootform/synthetic/managed"
  data_json = jsonencode({
    token  = random_password.automation.result
    marker = "ROOTFORM_SECRET_VALUE_SENTINEL"
  })
}
