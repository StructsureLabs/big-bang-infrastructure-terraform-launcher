resource "kubernetes_namespace" "namespace_flux_system" {
  count = var.create_flux_system_ns ? 1 : 0
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubernetes_namespace" "namespace_bigbang" {
  count = var.create_bigbang_ns ? 1 : 0
  metadata {
    name = "bigbang"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}
