Pangolin
=========

Configures a single-node Pangolin stack (Pangolin + Traefik + optional Gerbil/CrowdSec/GeoIP).

This role is focused on:
- Rendering config into `pangolin_project_dir` (default: `/srv/pangolin`)
- Bringing the stack up via `docker compose up -d` when config changes

Requirements
------------

- Docker is installed via the role dependency `geerlingguy.docker` (see `meta/main.yml`).
- Compose support:
  - Docker: `docker compose` (provided by the Docker installation)
  - Podman: `podman compose` (only relevant if you switch `pangolin_runtime`)
- `curl` available (used by container healthchecks)

Role Variables
--------------

See `defaults/main.yml` for the full list. The key variables are:

**Required**
- `pangolin_base_domain`: Base domain used by Pangolin.
- `pangolin_dashboard_domain`: Public hostname for the Pangolin dashboard (Traefik routes + app URLs).
- `pangolin_letsencrypt_email`: ACME email for Traefik.
- `pangolin_server_secret`: Pangolin server secret used for signing/session security.

**Runtime / lifecycle**
- `pangolin_runtime`: `docker` (default) or `podman`.
- `pangolin_project_dir`: Base directory for the compose project (default: `/srv/pangolin`).
- `pangolin_owner_user` / `pangolin_owner_group`: Ownership for rendered files/dirs (default: `ops`/`ops`).
- `pangolin_apply_compose`: If `true` (default), apply changes with `docker compose up -d --remove-orphans`.

**Images**
- `pangolin_image_tag`, `gerbil_image_tag`, `traefik_image_tag`, `crowdsec_image_tag`, `geoipupdate_image_tag`

**Features**
- `pangolin_install_gerbil`: Expose ports via Gerbil container (default: `true`).
- `pangolin_enable_crowdsec`: Enable Traefik CrowdSec bouncer + CrowdSec container (default: `false`).
- `pangolin_enable_geoblocking`: Enable MaxMind GeoLite2 database updates (default: `false`).
- `pangolin_enable_integration_api`: Expose Pangolin Integration API via Traefik (default: `false`).

**Pangolin app config (opinionated defaults, overridable)**
- `pangolin_app_log_level`: `info` by default.
- `pangolin_telemetry_anonymous_usage`: `true` by default.
- `pangolin_disable_signup_without_invite`: `true` by default.
- `pangolin_disable_user_create_org`: `false` by default.
- `pangolin_allow_raw_resources`: `true` by default.

**Secrets (store in Vault)**
- `pangolin_maxmind_account_id`, `pangolin_maxmind_license_key` (required when `pangolin_enable_geoblocking: true`)
- `pangolin_crowdsec_lapi_key` (required for CrowdSec bouncer)

Notes:
- When `pangolin_enable_geoblocking: true`, the role writes MaxMind credentials to `pangolin_env_file_path` and starts `geoipupdate`.
- When `pangolin_enable_crowdsec: true`, the role renders Traefik plugin config that includes the CrowdSec LAPI key.

Dependencies
------------

- `geerlingguy.docker` (declared in `meta/main.yml`, so it is installed/applied automatically when this role runs).

Example Playbook
----------------

**Standard setup (minimal)**

This brings up Pangolin + Traefik + Gerbil with LetsEncrypt, without CrowdSec/GeoIP:

```yaml
- hosts: tunnel
  become: true
  roles:
    - role: pangolin
  vars:
    pangolin_base_domain: "example.com"
    pangolin_dashboard_domain: "pangolin.example.com"
    pangolin_letsencrypt_email: "me@example.com"
    pangolin_server_secret: "{{ vault_pangolin_server_secret }}"

    pangolin_image_tag: "latest"
    gerbil_image_tag: "latest"
    traefik_image_tag: "latest"
    pangolin_install_gerbil: true
```

**Custom setup (optional features)**

Enable CrowdSec and GeoIP updates (store credentials in Vault):

```yaml
- hosts: tunnel
  become: true
  roles:
    - role: pangolin
  vars:
    pangolin_enable_crowdsec: true
    pangolin_crowdsec_lapi_key: "{{ vault_pangolin_crowdsec_lapi_key }}"

    pangolin_enable_geoblocking: true
    pangolin_maxmind_account_id: "{{ vault_pangolin_maxmind_account_id }}"
    pangolin_maxmind_license_key: "{{ vault_pangolin_maxmind_license_key }}"

    pangolin_env_extra:
      GEOIPUPDATE_EDITION_IDS: "GeoLite2-Country GeoLite2-ASN"
      GEOIPUPDATE_FREQUENCY: "72"
```

Initial Pangolin application setup (creating the first admin user/org/site, configuring SSO/IDPs, etc.) is intentionally not automated by this role; do it via the UI/API after the stack is running.

License
-------

MIT-0 (see role metadata).

Author Information
------------------

Paul Tibbetts
