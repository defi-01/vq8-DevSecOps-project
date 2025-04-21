#!/bin/bash

# Start Vault and Jenkins with docker-compose
docker-compose up -d

# Wait for Vault to be ready
sleep 5

# Check if Vault is running
if ! curl -s http://127.0.0.1:8200/v1/sys/health > /dev/null; then
  echo "Error: Vault is not running!"
  exit 1
fi

# Export environment variables (for local checks)
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'

# Run Vault commands inside the container with VAULT_TOKEN passed via -e
docker exec -e VAULT_TOKEN=root vault vault secrets enable -path=vq8-secrets -version=2 kv
docker exec -e VAULT_TOKEN=root vault vault kv put -mount=vq8-secrets creds username=user password=password

docker exec -e VAULT_TOKEN=root vault vault auth enable userpass
docker exec -e VAULT_TOKEN=root vault vault policy write vq8-secrets /vault/config/vq8-policy.hcl
docker exec -e VAULT_TOKEN=root vault vault write auth/userpass/users/admin password=password policies=vq8-secrets

docker exec -e VAULT_TOKEN=root vault vault secrets enable -path=totp totp
docker exec -e VAULT_TOKEN=root vault vault write totp/keys/vq8-key \
    url="otpauth://totp/Vault:test@test.com?secret=Y64VEVMBTSXCYIWRSHRNDZW62MPGVU2G&issuer=Vault"
docker exec -e VAULT_TOKEN=root vault vault read totp/code/vq8-key

# Setup for Jenkins (AppRole)
docker exec -e VAULT_TOKEN=root vault vault policy write jenkins /vault/config/jenkins-policy.hcl
docker exec -e VAULT_TOKEN=root vault vault auth enable approle
docker exec -e VAULT_TOKEN=root vault vault write auth/approle/role/jenkins token_num_uses=0 secret_id_num_uses=0 secret_id_ttl=30d policies=jenkins

# Retrieve role-id and secret-id for Jenkins
echo "Jenkins Role ID:"
docker exec -e VAULT_TOKEN=root vault vault read auth/approle/role/jenkins/role-id
echo "Jenkins Secret ID:"
docker exec -e VAULT_TOKEN=root vault vault write -f auth/approle/role/jenkins/secret-id

echo "Setup complete!" 
