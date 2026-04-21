#!/usr/bin/env bash
set -euo pipefail

echo "Waiting for Kubernetes API..."
until kubectl get nodes >/dev/null 2>&1; do
  sleep 5
done

echo "=== Uncordoning all nodes ==="
kubectl get nodes -o name | while read -r node; do
  kubectl uncordon "${node#node/}" || true
done

echo
kubectl get nodes
echo "Startup recovery complete."
