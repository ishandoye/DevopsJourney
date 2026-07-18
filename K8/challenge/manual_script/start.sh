#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHALLENGE_DIR="${CHALLENGE_DIR:-$SCRIPT_DIR}"
NAMESPACE="${NAMESPACE:-access-pending}"
TIMEOUT="${TIMEOUT:-120s}"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "error: required command '$1' not found in PATH" >&2
    exit 1
  }
}

require_cmd kubectl

ns_file="${CHALLENGE_DIR}/manifests/namespace.yaml"
pol_dir="${CHALLENGE_DIR}/policies"
man_dir="${CHALLENGE_DIR}/manifests"

if [[ ! -d "${man_dir}" ]]; then
  echo "error: manifests directory not found: ${man_dir}" >&2
  exit 1
fi

if [[ -f "${ns_file}" ]]; then
  echo "==> Applying namespace"
  kubectl apply -f "${ns_file}"
fi

if compgen -G "${pol_dir}/*.yaml" >/dev/null 2>&1 || compgen -G "${pol_dir}/*.yml" >/dev/null 2>&1; then
  echo "==> Applying policies"
  for f in "${pol_dir}"/*.yaml "${pol_dir}"/*.yml; do
    [[ -e "$f" ]] || continue
    kubectl apply -f "$f"
  done
fi

echo "==> Applying manifests"
for f in "${man_dir}"/*.yaml "${man_dir}"/*.yml; do
  [[ -e "$f" ]] || continue
  case "$(basename "$f")" in
    namespace.yaml) continue ;;
    *.yaml|*.yml) kubectl apply -f "$f" ;;
  esac
done

echo "==> Waiting briefly for the challenge pod to appear"
if ! kubectl wait -n "${NAMESPACE}" --for=condition=Ready pod -l app=startup-app --timeout="${TIMEOUT}"; then
  echo "note: pod is not Ready yet. This is expected before the RBAC fix."
fi

echo "==> Current pod status"
kubectl config set-context --current --namespace=$NAMESPACE
kubectl get pods -n "${NAMESPACE}" -o wide || true


