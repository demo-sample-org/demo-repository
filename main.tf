 terraform {
       backend "remote" {
         # The name of your Terraform Cloud organization.
         organization = "demo-test-organisation"

         # The name of the Terraform Cloud workspace to store Terraform state files in.
         workspaces {
           name = "demo-repository"
         }
       }
     }
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "demo-resource-group"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "example" {
  name                = "demo-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_web_app" "example" {
  name                = "demo-web-app"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  server_farm_id      = azurerm_app_service_plan.example.id
  site_config {
    app_command_line = ""
    linux_fx_version = "JAVA|11-java11"
  }
}

output "web_app_url" {
  value = azurerm_web_app.example.default_site_hostname
}
