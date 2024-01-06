terraform {
  backend "local" {
    path = "./.terraform.tfstate"
  }

  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = ">= 2.17.1"
    }
  }

  required_version = ">= 1.6.5"
}

provider "vultr" {
  api_key = var.VULTR_API_KEY
}

variable "VULTR_API_KEY" {
  description = "Current personal best practice is to inject this var via the shell's environment"
  type        = string
}
