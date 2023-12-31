# Terramox 🏗️
All this repo contains infrastructure for my proxmox server
## Step by step init

1. Run `cd packer/template` and `packer init config.pkr.hcl`
2. Run `packer build -var "myvar=value" debian-template`
3. Deploy infrastructure with `cd terraform/environment/prod; terraform init; terraform apply`
4. Connect to Bastion with `ssh nicolas@bastion` then change the password (not set)
5. Once infrastructure is deployed, post-config for k3s_environment run `cd ansible; ansible-playbook -i inventories/prod/hosts playbooks/k3s-postconf-playbook.yml`
## Environment variables

| Name | Default value | Mandatory | Description  |
|---|---|---|---|
| `PM_API_URL`  |      | ✅ | *URL is the hostname (FQDN if you have one) for the proxmox host you'd like to connect to to issue the commands. Add /api2/json at the end for the API* |
| `PM_API_TOKEN_ID`  |   | ✅ | *API token id is in the form of: <username>@pam!<tokenId>* |
| `PM_API_TOKEN_SECRET`  |   | ✅  | *This is the full secret wrapped in quotes* |
| `PM_TLS_INSECURE`  | `true`  | ✅ | *Leave tls_insecure set to true unless you have your proxmox SSL certificate situation fully sorted out (if you do, you will know)* |

