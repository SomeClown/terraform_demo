# Configure the Azure provider
provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  version         = "1.33.1"
}

provider "random" {
  version = "~> 2.2"
}

variable admin_username {
  type        = string
  default     = "azureuser"
}

variable admin_password {
  type        = string
  default     = "FooBar$1959"
}

variable "subscription_id" {
}

variable "tenant_id" {
}

variable "client_id" {
}

variable "client_secret" {
}

variable "location" {
  type        = string
  default     = "West US"
  description = "Where we create our resources"
}

variable "tags" {
  type        = map
  description = "A list of tags for resources"
  default = {
    Maintained_by   = "Teren Bryson"
    Author          = "Teren Bryson"
    Environment     = "Demo"
  }
}