concept "plugin-configuration" {
  description = "A plugin registration or version setting supporting a Vault plugin runtime."
}

concept "plugin-runtime" {
  description = "A runtime boundary executing external Vault plugins."
}

rule "plugin" {
  match {
    type = "vault_plugin"
  }

  as = concept.plugin-configuration
}

rule "plugin-pinned-version" {
  match {
    type = "vault_plugin_pinned_version"
  }

  as = concept.plugin-configuration
}

rule "plugin-runtime" {
  match {
    type = "vault_plugin_runtime"
  }

  as = concept.plugin-runtime

  context {
    as  = context.ownership
    to  = concept.namespace
    via = source.namespace
  }
}
