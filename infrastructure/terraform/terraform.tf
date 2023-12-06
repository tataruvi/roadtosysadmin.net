terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = ">= 2.17.1"
    }
  }

  required_version = ">= 1.6.5"
}

terraform {
  backend "local" {
    path = "./.terraform/terraform.tfstate"
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key = "VULTR_API_KEY_env_var"
}

