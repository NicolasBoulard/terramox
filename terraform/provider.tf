provider "proxmox" {

  pm_api_url = variables.pm_api_url

  pm_api_token_id = variables.pm_api_token_id

  pm_api_token_secret = variables.pm_api_token_secret

  pm_tls_insecure = variables.pm_tls_insecure
}