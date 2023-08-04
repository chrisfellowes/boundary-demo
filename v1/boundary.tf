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
}

resource "boundary_scope" "databases" {
  name                   = "databases"
  description            = "Databases"
  scope_id               = boundary_scope.kapstan.id
  auto_create_admin_role = true
}

resource "boundary_target" "kapstan-db" {
  name         = "kapstan-db"
  description  = "kapstan database"
  type         = "tcp"
  default_port = "5432"
  scope_id     = boundary_scope.databases.id
  address      = "127.0.0.1"
}