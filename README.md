# 🔐 [Vault + Jenkins Integration for Secrets Management] 🔐
## ☁️ • vq8-vault-jenkins-project • ☁️
#### This project sets up a local development environment using HashiCorp Vault and Jenkins via Docker Compose. It demonstrates secure secrets management and dynamic credential injection into Jenkins using Vault's AppRole authentication method. The setup is fully automated, with all Vault configurations applied via Bash scripts. Jenkins is integrated with Vault to pull secrets securely during CI/CD pipeline execution.

![Vault and Jenkins Integration with Docker Compose - visual selection (1)](https://github.com/user-attachments/assets/ccbb30f0-8a4a-4cea-a677-d85308413b63)

- 🐳 Runs Vault and Jenkins with Docker Compose

- 🔐 Enables Vault KV v2 secrets engine

- 👤 Creates user-based and AppRole-based authentication

- 🔐 Stores secrets (e.g., Jenkins credentials) in Vault

- ✅ Configures Vault policies for controlled access

- 📲 Generates TOTP (time-based one-time password) for extra security

- 🔄 Retrieves AppRole credentials (role_id & secret_id) for Jenkins

- 💻 An easy bootstrap script to start everything

#### 🚀 How to Run
```bash
bash vault-setup.sh
```
