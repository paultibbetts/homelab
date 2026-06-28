# web-app

Reusable internal Helm chart for simple HTTP application containers.

It creates a Deployment, Service, and optional Ingress. It does not create secrets, TLS resources, databases, or cert-manager resources. Use `image.value` for a complete image reference, or `image.repository`, `image.tag`, and optional `image.digest` when the reference should be composed by the chart.
