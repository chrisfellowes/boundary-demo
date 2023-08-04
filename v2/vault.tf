resource "vault_policy" "boundary" {
  name = "boundary"

  policy = <<EOT
    path "auth/token/lookup-self" {
      capabilities = ["read"]
    }

    path "auth/token/renew-self" {
      capabilities = ["update"]
    }

    path "auth/token/revoke-self" {
      capabilities = ["update"]
    }

    path "sys/leases/renew" {
      capabilities = ["update"]
    }

    path "sys/leases/revoke" {
      capabilities = ["update"]
    }

    path "sys/capabilities-self" {
      capabilities = ["update"]
    }

    path "database/creds/kapstan-db" {
      capabilities = ["read"]
    }
  EOT
}

resource "vault_token" "boundary" {
  policies = ["boundary"]

  no_parent = true
  renewable = true

  period = "24h"
  ttl = "24h"

}

resource "vault_database_secrets_mount" "database" {
  path = "database"

  postgresql {
    name              = "kapstan"
    username          = "postgres"
    password          = "secret"
    allowed_roles       = ["kapstan-db"]
    connection_url    = "postgresql://{{username}}:{{password}}@127.0.0.1:5432/kapstan"
    verify_connection = true
    plugin_name = "postgresql-database-plugin"
  }
}

resource "vault_database_secret_backend_role" "role" {
  backend             = vault_database_secrets_mount.database.path
  name                = "kapstan-db"
  db_name             = "kapstan"
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"]
}