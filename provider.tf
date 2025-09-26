terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.45.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "790084ef-9e9f-4ebf-9120-98c5295aba2a"
}