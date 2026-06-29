#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Generates the SSH key pair used for the controller <-> agent connection.
#
#   ssh-keys/jenkins_agent_key       (PRIVATE) -> given to the controller
#   ssh-keys/jenkins_agent_key.pub   (PUBLIC)  -> baked into the agent image
#
# Re-running is safe: it won't overwrite an existing key.
# ---------------------------------------------------------------------------
set -euo pipefail

# Resolve the project root (parent of this script's directory).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY_DIR="${SCRIPT_DIR}/../ssh-keys"
KEY_FILE="${KEY_DIR}/jenkins_agent_key"

mkdir -p "${KEY_DIR}"

if [[ -f "${KEY_FILE}" ]]; then
  echo "Key already exists at ${KEY_FILE} — leaving it untouched."
  exit 0
fi

# RSA-4096 for maximum compatibility with the Jenkins SSH stack.
# (ed25519 also works on current Jenkins; swap -t rsa -b 4096 for -t ed25519
#  if you prefer.)
ssh-keygen -t rsa -b 4096 -f "${KEY_FILE}" -N "" -C "jenkins-agent"

echo
echo "Generated:"
echo "  private: ${KEY_FILE}"
echo "  public : ${KEY_FILE}.pub"
