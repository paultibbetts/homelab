# Dev Workloads

`dev/apps/` contains manually declared, long-lived developer and development app deployments.

`dev/previews/` is reserved for future generated, ephemeral preview deployments.

The root manifests in `dev/root/` define the dev Argo CD project and ApplicationSets. Dev apps use small wrapper charts that depend on the reusable internal `charts/web-app` chart for HTTP application containers.
