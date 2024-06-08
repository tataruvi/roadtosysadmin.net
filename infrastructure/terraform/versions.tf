terraform {
  backend "local" {
    path = "./.terraform/rtsa_infra_resources.tfstate.local"
  }

  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = ">= 2.17.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.5"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
  }

  required_version = ">= 1.6.5"
}

provider "tls" {}
provider "local" {}

provider "vultr" {
  api_key = var.VULTR_API_KEY
}

variable "VULTR_API_KEY" {
  description = "API key for the Vultr account, provided via the environment"
  type        = string
  sensitive   = true
}
