# TrueNAS custom monitoring

This directory contains deployment-specific monitoring resources. It is intentionally
separate from the upstream `kube-prometheus-stack` Helm values in `../../values.yaml`.
The existing `monitoring-system` Argo CD application deploys both: a separate
application would be unnecessary and would not match the repository's ApplicationSet
convention.

## Prerequisites

Create a least-privileged, read-only API key in TrueNAS, then create its Kubernetes
Secret manually; do not commit the key:

```sh
kubectl -n monitoring-system create secret generic truenas-exporter-api \
  --from-literal=api-key='<TRUENAS_READ_ONLY_API_KEY>'
```

The exporter connects to `wss://nas.infra.home.arpa/api/current` with TLS verification
enabled. The cluster nodes must resolve that name and trust the CA that issued the
TrueNAS certificate. If the certificate uses a private CA, add that CA to the node and
workload trust distribution already used by the cluster before syncing; do not set
`TRUENAS_VERIFY_TLS=false`.

`nas.infra.home.arpa` reachability cannot be established from this repository. Before
syncing, test DNS, TCP/443, and the certificate chain from a temporary in-cluster pod.

The dashboard ConfigMap is in `dashboards/truenas-storage.json`. Grafana's existing
sidecar already searches `monitoring-system` for `grafana_dashboard: "1"` ConfigMaps.

## Alerting and ntfy

`templates/truenas/alertmanagerconfig.yaml` uses the ntfy Alertmanager template at:

`http://10.1.21.10:8093/truenas?template=alertmanager`

The `AlertmanagerConfig` only matches alerts labelled
`monitoring.paultibbetts.uk/target: truenas`; it does not replace existing routes or
receivers. The small `alertmanagerConfigSelector` addition in `values.yaml` is needed
solely so the existing Alertmanager selects this labelled config.

If ntfy requires bearer authentication, create the Secret manually and set its name in
`values.yaml` under `truenas.ntfy.auth.existingSecret` before syncing:

```sh
kubectl -n monitoring-system create secret generic truenas-ntfy-auth \
  --from-literal=token='<NTFY_ACCESS_TOKEN>'
```

Create the dedicated ntfy account and a write-only ACL on the host (or container) that
runs the ntfy server. These commands require ntfy's auth database to be enabled and
must be run with the permissions used to administer that server:

```sh
ntfy user add truenas-alertmanager
ntfy access truenas-alertmanager truenas write-only
ntfy token add --label=alertmanager truenas-alertmanager
```

Copy the token printed by the last command into the Kubernetes Secret above, then set:

```yaml
truenas:
  ntfy:
    auth:
      existingSecret: truenas-ntfy-auth
```

The receiver is deliberately unauthenticated until that explicit setting is made, since
the repository does not reveal the ntfy access policy. Do not leave the topic anonymous
if the ntfy instance is intended to be private.

## Validation after sync

```sh
kubectl -n monitoring-system get deploy,svc,servicemonitor,prometheusrule,alertmanagerconfig | grep truenas
kubectl -n monitoring-system port-forward svc/truenas-exporter 9108:9108
curl -fsS http://127.0.0.1:9108/healthz
curl -fsS http://127.0.0.1:9108/metrics | grep '^truenas_'
```

In Prometheus, confirm `up{job="truenas-exporter"} == 1` and `truenas_up == 1` before
relying on the dashboard or alerts. Confirm pool, dataset, and hardware metric families
exist; unavailable hardware will naturally omit IPMI/S.M.A.R.T. series. Use a temporary
PrometheusRule that always fires with the TrueNAS target label to test warning, critical,
and resolved ntfy delivery, then remove it. Do not fill pools or degrade ZFS to test.

## Upgrades and future custom monitoring

The exporter image is pinned by digest in `templates/truenas/deployment.yaml`. For an
upgrade, review upstream release notes and metric changes, test against the installed
TrueNAS version, replace the digest, render the chart, and verify the metric names used
by dashboards and rules. Add future exporters, rules, and dashboards under
`templates/<integration>/` and `custom/<integration>/`; keep stack-wide Helm settings
in `values.yaml` and integration-specific resources out of it.
