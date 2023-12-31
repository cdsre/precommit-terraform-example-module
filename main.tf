locals {
  alice = true
  bob = false
}

resource "null_resource" "this" {
  depends_on = [var.foo, var.bar, local.alice]
}

resource "fake_provider_resource" "dummy" {

}