terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"   # or the version you need
    }
  }

  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}          # required block to enable provider features

  # Optional: authenticate with environment variables
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
  subscription_id = "10453ec5-bcb7-4ed7-9f6c-4e741f3611a8"
}
