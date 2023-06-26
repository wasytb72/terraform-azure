data "azuread_client_config" "current" {}
data "azurerm_subscription" "main-subs" {
    subscription_id = var.subscription_id
}

resource "random_string" "random-name" {
  length = 5
  upper = false
  lower = true
  numeric = true
  special = false
}

resource "azuread_application" "training-app" {
  display_name = "training-adapp-${random_string.random-name.result}"
}

resource "azuread_service_principal" "training-sp" {
  application_id = azuread_application.training-app.application_id
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "training-passwd" {
  service_principal_id = azuread_service_principal.training-sp.id
  end_date_relative    = "17520h" #2y
}

resource "azurerm_role_assignment" "reader" {
  scope = "${data.azurerm_subscription.main-subs.id}" //Expects ID in string format
  role_definition_name = "Reader"
  principal_id = azuread_service_principal.training-sp.id
}