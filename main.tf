# create resource group
resource "azurerm_resource_group" "demo" {
  name     = "Demo_Resources"
  location = var.location
  tags     = "${var.tags}"
}

# The much vaunted random ID
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.demo.name}"
  }
  byte_length = 8
}

# Create virtual network
resource "azurerm_virtual_network" "demo" {
  name                = "TvNet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = "${azurerm_resource_group.demo.name}"
  tags     = "${var.tags}"

}

# Create subnet
resource "azurerm_subnet" "demo" {
  name                 = "TSub"
  resource_group_name  = "${azurerm_resource_group.demo.name}"
  virtual_network_name = "${azurerm_virtual_network.demo.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create Public IP
resource "azurerm_public_ip" "demo" {
  name                = "PubIP"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.demo.name}"
  allocation_method   = "Static"
  domain_name_label   = "umbrellacorp"
  tags     = "${var.tags}"
}

# Create Storage account for boot
resource "azurerm_storage_account" "demo" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.demo.name}"
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  tags                     = "${var.tags}"
}
