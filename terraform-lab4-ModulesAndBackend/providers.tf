terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # 🔒 Remote Backend Configuration
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-prod"
    storage_account_name = "sttfstate2023210391"
    container_name       = "tfstate"
    key                  = "lab4.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}