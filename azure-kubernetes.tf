variable "sid" {
  default = "groupc"
}

variable "cid" {
  default = "groupc"
}

variable "cs" {
  default = "groupc"
}

variable "tid" {
  default = "groupc"
}

provider "azurerm" {
    subscription_id = "${var.sid}"
    client_id       = "${var.cid}"
    client_secret   = "${var.cs}"
    tenant_id       = "${var.tid}"
}

variable "prefix" {
  default = "groupc"
}

resource "azurerm_resource_group" "azure-rg" {
  name     = "${var.prefix}-kubrg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "azure-kub-cluster" {
  name                = "${var.prefix}-cluster"
  location            = "${azurerm_resource_group.azure-rg.location}"
  resource_group_name = "${azurerm_resource_group.azure-rg.name}"
  dns_prefix          = "acctestagent1"

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  agent_pool_profile {
    name            = "pool2"
    count           = 1
    vm_size         = "Standard_D2_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }
  
    service_principal {
    client_id     = "${var.cid}"
    client_secret = "${var.cs}"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.azure-kub-cluster.kube_config.0.client_certificate}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.azure-kub-cluster.kube_config_raw}"
}
