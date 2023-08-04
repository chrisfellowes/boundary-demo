terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.8"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.12.0"
    }
  }
}

provider "boundary" {
  addr                            = "http://127.0.0.1:9200"
  auth_method_id                  = "ampw_1234567890"
  password_auth_method_login_name = "admin"
  password_auth_method_password   = "password"
}

provider "vault" {
  address         = "http://127.0.0.1:8200"
  token           = "secret"
  skip_tls_verify = true
}