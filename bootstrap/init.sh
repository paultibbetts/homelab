#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

helm template argocd "${repo_root}/bootstrap/argocd" \
  --namespace argocd \
  --dependency-update \
  -f "${repo_root}/bootstrap/argocd/values-seed.yaml" | kubectl apply --server-side -f -

kubectl wait --for=condition=Established --timeout=120s crd/applications.argoproj.io
kubectl wait --for=condition=Established --timeout=120s crd/appprojects.argoproj.io
kubectl wait --for=condition=Established --timeout=120s crd/applicationsets.argoproj.io

helm template cluster "${repo_root}/bootstrap/cluster" \
  --namespace argocd \
  -f "${repo_root}/bootstrap/cluster/values.yaml" | kubectl apply --server-side -f -
