terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "= 5.3.0" }
  }
}

variable "unknown_id" { type = string }

resource "azurerm_resource_group" "platform" {
  name     = "platform"
  location = "West Europe"
}

resource "azurerm_dns_zone" "public" {
  name                = "example.com"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_dns_a_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.platform.name
  ttl                 = 300
  records             = ["203.0.113.10"]
}

resource "azurerm_dns_aaaa_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.platform.name
  ttl                 = 300
  records             = ["2001:db8::10"]
}

resource "azurerm_dns_cname_record" "shop" {
  name                = "shop"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.platform.name
  ttl                 = 300
  record              = "www.example.com"
}

resource "azurerm_dns_mx_record" "mail" {
  name                = "@"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.platform.name
  ttl                 = 300

  record {
    preference = 10
    exchange   = "mail.example.com"
  }
}

resource "azurerm_dns_ns_record" "delegated" {
  name                = "delegated"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.platform.name
  ttl                 = 300
  records             = ["ns1.example.net"]
}

resource "azurerm_dns_ptr_record" "reverse" {
  name                = "10"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.platform.name
  ttl                 = 300
  records             = ["www.example.com"]
}

resource "azurerm_dns_srv_record" "sip" {
  name                = "_sip._tcp"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.platform.name
  ttl                 = 300

  record {
    priority = 1
    weight   = 5
    port     = 5060
    target   = "sip.example.com"
  }
}

resource "azurerm_dns_txt_record" "verification" {
  name                = "@"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.platform.name
  ttl                 = 300

  record {
    value = "rootform-site-verification"
  }
}

resource "azurerm_private_dns_zone" "internal" {
  name                = "internal.example"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_private_dns_a_record" "api" {
  name                = "api"
  private_dns_zone_id = azurerm_private_dns_zone.internal.id
  ttl                 = 300
  records             = ["10.20.1.10"]
}

resource "azurerm_private_dns_cname_record" "db" {
  name                = "db"
  private_dns_zone_id = azurerm_private_dns_zone.internal.id
  ttl                 = 300
  record              = "api.internal.example"
}

# literal and unknown zone references produce no contribution
resource "azurerm_dns_a_record" "literal" {
  name                = "literal"
  zone_name           = "example.com"
  resource_group_name = azurerm_resource_group.platform.name
  ttl                 = 300
  records             = ["203.0.113.11"]
}

resource "azurerm_private_dns_a_record" "unknown" {
  name                = "unknown"
  private_dns_zone_id = var.unknown_id
  ttl                 = 300
  records             = ["10.20.1.11"]
}
