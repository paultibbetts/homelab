#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <traefik-chart-version>" >&2
  exit 1
fi

chart_version="$1"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output="${repo_root}/system/traefik/templates/crds.yaml"

command -v yq >/dev/null || {
  echo "yq is required to add Argo CD sync-wave annotations to the CRDs" >&2
  exit 1
}

mkdir -p "$(dirname "${output}")"

helm repo add traefik https://traefik.github.io/charts
helm repo update
helm show crds traefik/traefik --version "${chart_version}" \
  | yq eval 'select(.kind == "CustomResourceDefinition") | .metadata.annotations."argocd.argoproj.io/sync-wave" = "-10"' - \
  > "${output}"

