# terramox 🏗️
All this repo contains infrastructure for my proxmox server

## Environment variables

| Name | Default value | Mandatory | Description  |
|---|---|---|---|
| `PM_API_URL`  |      | ✅ | *URL is the hostname (FQDN if you have one) for the proxmox host you'd like to connect to to issue the commands. Add /api2/json at the end for the API* |
| `PM_API_TOKEN_ID`  |   | ✅ | *API token id is in the form of: <username>@pam!<tokenId>* |
| `PM_API_TOKEN_SECRET`  |   | ✅  | *This is the full secret wrapped in quotes* |
| `PM_TLS_INSECURE`  | `true`  | ✅ | *Leave tls_insecure set to true unless you have your proxmox SSL certificate situation fully sorted out (if you do, you will know)* |
