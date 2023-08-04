resource "boundary_scope" "global" {
  global_scope = true
  description = "Global Scope"
  name         = "global"
  scope_id     = "global"
}

resource "boundary_scope" "kapstan" {
  name        = "Kapstan"
  description = "Kapstan Boundary Scope"
  scope_id    = boundary_scope.global.id
  auto_create_admin_role = true
}

resource "boundary_scope" "databases" {
  name                   = "databases"
  description            = "Databases"
  scope_id               = boundary_scope.kapstan.id
  auto_create_admin_role = true
}

### V2 Code ###
resource "boundary_credential_store_vault" "vault" {
  name        = "vault"
  description = "Credential Store"
  address     = "http://127.0.0.1:8200"
  token       = vault_token.boundary.client_token
  scope_id    = boundary_scope.databases.id
}

resource "boundary_credential_library_vault" "kapstan-db" {
  name                = "kapstan-db"
  description         = "Credential Library for kapstan-db"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "database/creds/kapstan-db"
  http_method         = "GET"
  credential_type     = "username_password"
}

resource "boundary_target" "kapstan-db" {
  name         = "kapstan-db"
  description  = "kapstan database"
  type         = "tcp"
  default_port = "5432"
  scope_id     = boundary_scope.databases.id
  address      = "127.0.0.1"
  brokered_credential_source_ids = [
    boundary_credential_library_vault.kapstan-db.id
  ]
}
