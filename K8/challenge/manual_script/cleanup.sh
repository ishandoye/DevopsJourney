#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHALLENGE_DIR="${CHALLENGE_DIR:-$SCRIPT_DIR}"
NAMESPACE="${NAMESPACE:-access-pending}"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "error: required command '$1' not found in PATH" >&2
    exit 1
  }
}

require_cmd kubectl

echo "==> Deleting challenge manifests"
for f in "${CHALLENGE_DIR}/manifests"/*.yaml "${CHALLENGE_DIR}/manifests"/*.yml; do
  [[ -e "$f" ]] || continue
  kubectl delete -f "$f" --ignore-not-found=true || true
done

echo "==> Deleting challenge policies"
if [[ -d "${CHALLENGE_DIR}/policies" ]]; then
  for f in "${CHALLENGE_DIR}/policies"/*.yaml "${CHALLENGE_DIR}/policies"/*.yml; do
    [[ -e "$f" ]] || continue
    kubectl delete -f "$f" --ignore-not-found=true || true
  done
fi

echo "==> Deleting namespace"
kubectl delete namespace "${NAMESPACE}" --ignore-not-found=true || true

echo "==> Cleanup complete"
