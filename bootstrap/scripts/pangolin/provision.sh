#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$SCRIPT_DIR/../../"

if [[ -z "${MAKELEVEL:-}" ]]; then
  echo "ERROR: Do not run this script directly. Use 'make tunnel'." >&2
  exit 1
fi

pause() {
  echo ""
  echo "ACTION REQUIRED:"
  echo $1
  read -r -p "Press Enter to continue..." _
}

echo ""
read -r -p "Is this the initial setup? [Y/n] " response

case "$response" in
  [nN]|[nN][oO])
    source "$ANSIBLE_DIR/../metal/secrets.sh"
    uv run ansible-playbook site.yaml --limit tunnel
    ;;
  *)
    # 0) Warn about 'pangolin_crowdsec_lapi_key'
    pause "Ensure you have not set 'pangolin_crowdsec_lapi_key' in 'group_vars/tunnel/vault.yaml'"

    # 1) Load secrets required for the Terraform-based Ansible inventory to work
    source "$ANSIBLE_DIR/../metal/secrets.sh"

    # 2) Install Pangolin
    uv run ansible-playbook site.yaml --limit tunnel --tags pangolin

    # 3) Manual Pangolin steps

    pause "SSH in, 'cd /srv/pangolin && docker compose logs pangolin -f'"

    pause "Capture the token it generates to use for '/auth/initial-setup'"

    pause "Run 'docker exec -it crowdsec cscli bouncers add traefik-bouncer' and capture the key it generates"

    pause "Visit the Pangolin UI and create the admin user, the org, and a site called 'Home' with an ID of 'home'"

    pause "Create a MaxMind key at 'https://www.maxmind.com/en/accounts/<id>/license-key'"

    pause "Store credentials using 'ansible-vault edit group_vars/tunnel/vault.yaml'"

    # 4) Install Newt with auth blueprint
    uv run ansible-playbook playbooks/tunnel.yaml --tags newt \
      --extra-vars "newt_blueprint_mode=auth-only"

    # 5) Register IDP for Pangolin SSO
    pause "Visit Pangolin and register the IDP. Set the default mappings. The IDP ID should be 1."

    # 6) Run Newt with full blueprint using the IDP ID
    uv run ansible-playbook playbooks/tunnel.yaml --tags newt
    ;;
esac

echo "Done."
