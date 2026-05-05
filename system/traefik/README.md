# Traefik CRDs

Traefik is deployed by Argo CD from the official `traefik/traefik` Helm chart,
but Helm does not upgrade CRDs after the initial install.
Traefik release notes sometimes require CRDs to be upgraded before the chart
version changes, so the CRDs are managed here as plain Kubernetes manifests
in this wrapper chart instead of being managed by the upstream Helm dependency.

When upgrading Traefik, check the release notes. If they mention CRD changes, run:

```sh
./hack/update-traefik-crds.sh <chart-version>
```

Commit `system/traefik/templates/crds.yaml` in the same change as the Traefik
chart version bump. Argo CD skips the upstream chart CRDs via
`.argocd-source.yaml`, then applies these CRDs with server-side apply and a
negative sync wave before the Traefik Helm resources are applied.
