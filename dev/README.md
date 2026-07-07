# Dev Workloads

`dev/apps/` contains manually declared, long-lived developer and development app deployments.

`dev/previews/` contains small preview deployment specs. The dev preview ApplicationSet turns each `*.yaml` file into an Argo CD Application.

Most HTTP app previews should use `preset: web-app` and provide only the app-specific Helm values. The ApplicationSet renders them with `charts/web-app` and supplies the shared preview ingress and resource defaults; the spec only needs to provide the preview `host`.

Previews that need extra Kubernetes resources, databases, or a different values shape can use a custom `preset` and point `sourcePath` at a dedicated chart directory. In that case, the spec's `helmValues` should include the full values required by that chart.

The root manifests in `dev/root/` define the dev Argo CD project and ApplicationSets. Dev apps use small wrapper charts that depend on the reusable internal `charts/web-app` chart for HTTP application containers.
