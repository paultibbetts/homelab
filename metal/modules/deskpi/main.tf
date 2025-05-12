resource "local_file" "deskpi_host" {
  content = templatefile("${path.root}/templates/host/hosts.tpl",
    {
      name = "deskpi"
      ip   = "192.168.1.133"
      user = "paul"
    }
  )
  filename = "../bootstrap/uptime/inventory/hosts"
}

