terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
      version = "1.85.1"
    }
  }
}

provider "routeros" { # Will be filled manually during planning or apply or given by .env file
  hosturl = var.hosturl
  username = var.username
  password = var.password
  insecure = true
}
