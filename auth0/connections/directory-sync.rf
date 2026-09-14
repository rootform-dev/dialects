concept "directory-sync" {
  description = "An Auth0 Directory Sync integration attached to an enterprise Connection."
}

rule "connection-directory" {
  match {
    type = "auth0_connection_directory"
  }

  as = concept.directory-sync

  relation "synchronizes-connection" {
    to  = concept.identity-connection
    via = source.connection_id
  }
}

rule "connection-directory-lookup" {
  match {
    kind = "data"
    type = "auth0_connection_directory"
  }

  as = concept.directory-sync

  relation "synchronizes-connection" {
    to  = concept.identity-connection
    via = source.connection_id
  }
}
