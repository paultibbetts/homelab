resource "local_file" "artpi_host" {
  content = templatefile("${path.root}/templates/host/hosts.tpl",
    {
      name = "artpi"
      ip   = "192.168.1.132"
      user = "pi"
    }
  )
  filename = "../bootstrap/artpi/inventory/hosts"
}

