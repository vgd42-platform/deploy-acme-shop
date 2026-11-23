# Azure resources of shop (vendor acme).
# The vendor changes only the two values marked below, by PR. The platform module
# decides everything else (SKUs, security, naming).

# --- State lives in the platform's storage account (set by the infra workflow) ---
terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none" # registered once at bootstrap
}

# --- The platform module ---
module "vendor_kit" {
  source = "github.com/vgd42-platform/platform-config//modules/vendor-kit?ref=main"

  # Set at onboarding - don't change
  vendor                    = "acme"
  app                       = "shop"
  resource_group_name       = "rg-vgd42-acme-shop"
  storage_account_name      = "stvgd42acmeshop"
  app_identity_principal_id = "31ffcf79-4292-4979-9637-9265dc1c7636"

  # Vendor may change (PR, a code owner approves)
  containers = ["orders", "invoices"]
  enable_sql = false
}

output "blob_endpoint" {
  value = module.vendor_kit.blob_endpoint
}
