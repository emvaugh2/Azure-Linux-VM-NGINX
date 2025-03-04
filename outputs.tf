output "public_ip_address" {
    description = "Public IP of the Linux VM"
    value = azurerm_public_ip.lvmpip.ip_address
}

