# Demo made for Kapstan Blog post

### Setup
Install Boundary and Vault

```
brew tap hashicorp/tap
brew install hashicorp/tap/boundary
brew install hashicorp/tap/vault
```

Run Boundary and Vault in dev mode
```
boundary dev
vault server -dev -dev-root-token-id=secret
```

Install and run Postgres
```
docker pull postgres
docker run -d -e POSTGRES_PASSWORD=secret -e POSTGRES_DB="kapstan" --name kapstan -p 5432:5432 postgres
```

### Apply Terraform v1
```
cd v1
terraform init
terraform apply
```

Authenticate and find the Target ID
```
boundary authenticate -addr=127.0.0.1:9200
boundary targets list -recursive
```

Test the target
```
boundary connect postgres -target-id <your target id> -dbname kapstan -username postgres
```

### Apply Terraform v2
```
cd v2
terraform init
terraform apply
```

Test the target
```
boundary connect postgres -target-id <your target id> -dbname kapstan
```

### v3 and beyond...
integrating oidc
https://developer.hashicorp.com/boundary/tutorials/identity-management/oidc-auth 

other types of secret stores
https://developer.hashicorp.com/vault/docs/secrets