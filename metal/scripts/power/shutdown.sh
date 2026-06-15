#!/usr/bin/env bash
set -euo pipefail

CP_IPS=(
  10.1.21.70
  10.1.21.214
  10.1.21.178
)

TALOS_SHUTDOWN_WAIT="${TALOS_SHUTDOWN_WAIT:-false}"
TALOS_SHUTDOWN_TIMEOUT="${TALOS_SHUTDOWN_TIMEOUT:-5m}"
TALOS_SHUTDOWN_FORCE="${TALOS_SHUTDOWN_FORCE:-true}"

NODE_NAMES=()

get_node_name_by_ip() {
  local ip="$1"
  kubectl get nodes -o wide --request-timeout=10s | awk -v ip="$ip" '$0 ~ ip {print $1; exit}'
}

shutdown_node() {
  local ip="$1"
  local -a shutdown_args=(
    --endpoints "$ip"
    --nodes "$ip"
    --wait="${TALOS_SHUTDOWN_WAIT}"
    --timeout="${TALOS_SHUTDOWN_TIMEOUT}"
  )

  if [[ "${TALOS_SHUTDOWN_FORCE}" == "true" ]]; then
    shutdown_args+=(--force)
  fi

  echo "Shutting down Talos node $ip..."
  talosctl shutdown "${shutdown_args[@]}"

  if [[ "${TALOS_SHUTDOWN_WAIT}" == "true" ]]; then
    echo "Talos node $ip is off."
  else
    echo "Shutdown requested for Talos node $ip."
  fi
}

echo "=== Cordoning all nodes ==="
for i in "${!CP_IPS[@]}"; do
  ip="${CP_IPS[$i]}"
  node="$(get_node_name_by_ip "$ip")"
  if [[ -z "${node:-}" ]]; then
    echo "Could not find node name for IP $ip" >&2
    exit 1
  fi

  NODE_NAMES[$i]="$node"
  echo "Cordoning $node ($ip)..."
  kubectl cordon "$node" || true
done

echo
echo "=== Best-effort drain of each node ==="
echo "PDB-blocked Longhorn pods may prevent a full drain; that is expected."
for i in "${!CP_IPS[@]}"; do
  ip="${CP_IPS[$i]}"
  node="${NODE_NAMES[$i]}"

  echo "Draining $node ($ip)..."
  kubectl drain "$node" \
    --ignore-daemonsets \
    --delete-emptydir-data \
    --grace-period=60 \
    --timeout=120s || true
done

echo
echo "=== Pause to let workloads stop and volumes detach ==="
sleep 20

echo
echo "=== Shutting down control planes one-by-one ==="
for i in "${!CP_IPS[@]}"; do
  ip="${CP_IPS[$i]}"
  node="${NODE_NAMES[$i]:-unknown}"
  echo "About to shut down ${node:-unknown} ($ip)..."
  shutdown_node "$ip"

  echo "Waiting 30 seconds before the next control plane..."
  sleep 30
done

echo
echo "Shutdown sequence complete."
