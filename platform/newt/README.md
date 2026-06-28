# Newt

This chart deploys Newt as the Pangolin site connector for the Kubernetes cluster. The existing `platform` app-of-apps deploys this directory as the `newt` Argo CD application in the `newt` namespace.

Create the `newt-main-tunnel-auth` Secret in the `newt` namespace before syncing this app:

```sh
export PANGOLIN_ENDPOINT="https://pangolin.example.com"
export NEWT_ID="<newt-id>"
export NEWT_SECRET="<newt-secret>"

kubectl create namespace newt
kubectl create secret generic newt-main-tunnel-auth \
  --namespace newt \
  --from-literal=PANGOLIN_ENDPOINT="${PANGOLIN_ENDPOINT}" \
  --from-literal=NEWT_ID="${NEWT_ID}" \
  --from-literal=NEWT_SECRET="${NEWT_SECRET}"
```

For Pangolin Enterprise wildcard resources, point the wildcard resource target at the in-cluster Traefik HTTPS service:

```text
traefik.traefik.svc.cluster.local:443
```

The existing app ingress setup mostly routes through Traefik `websecure`, so HTTPS is the natural target. The Pangolin wildcard resource must preserve the original host header so Traefik can match each app's Kubernetes Ingress host.
