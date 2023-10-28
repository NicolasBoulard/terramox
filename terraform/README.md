# Terraform

## Init project
1. First go to the prod or dev environement with `cd environment/prod`
2. Do an `terraform init` to init the project
3. Do an `terraform apply -var 'pm_api_url=<>' -var 'pm_api_token_id=<>' -var 'pm_api_token_secret=<>' -var 'pm_tls_insecure=<>' -var 'pm_host=<>'`
    - Do an `terraform apply -var 'pm_api_url=<>' -var 'pm_api_token_id=<>' -var 'pm_api_token_secret=<>' -var 'pm_tls_insecure=<>' -var 'pm_host=<>' -destroy ` 