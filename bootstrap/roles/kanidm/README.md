Kanidm Role
===========

Deploys the [Kanidm](https://kanidm.com/) identity and access management server as a single Docker Compose application. The role renders a `server.toml`, writes an `.env` file consumed by Compose, and can generate a self-signed TLS bundle for the service.

Requirements
------------

- Docker Engine and docker-compose plugin pre-installed on the target host.
- The `docker_compose_app` role from this repository (invoked internally) to stage assets and manage container lifecycle.
- OpenSSL available on the control node when `kanidm_tls_generate` is true (default).

Role Variables
--------------

All variables live under `defaults/main.yml` unless noted.

| Variable | Default | Description |
| --- | --- | --- |
| `kanidm_app_name` | `kanidm` | Logical name passed to the shared `docker_compose_app` role. |
| `kanidm_app_path` | `/srv/www/apps/{{ kanidm_app_name }}` | Directory where docker-compose assets and persistent data are stored. |
| `kanidm_app_asset_dirs` | `[]` | Extra directories to copy from the role into the app path. Useful for bundling custom assets. |
| `kanidm_app_asset_files` | `[]` | Extra files to copy from the role into the app path. |
| `kanidm_domain` | `auth.cloud.paultibbetts.uk` | Public DNS name for the service, used in config and TLS subject. |
| `kanidm_origin` | `https://{{ kanidm_domain }}` | External origin URL advertised to clients. |
| `kanidm_https_port` | `8443` | Host port mapped to the container's HTTPS listener (443). |
| `kanidm_ldap_port` | `8636` | Host port mapped to the container's LDAP over TLS listener (636). |
| `kanidm_tls_chain_path` | `{{ kanidm_app_path }}/data/chain.pem` | Path where the TLS certificate chain is expected. |
| `kanidm_tls_key_path` | `{{ kanidm_app_path }}/data/key.pem` | Path to the TLS private key. |
| `kanidm_tls_generate` | `true` | When true the role calls `openssl` to mint a self-signed certificate if one does not already exist. Set to false to supply your own assets. |
| `kanidm_tls_validity_days` | `365` | Number of days the generated certificate remains valid. |
| `kanidm_tls_subject_alt_names` | `[ "DNS:{{ kanidm_domain }}" ]` | Additional SAN entries appended when generating certificates. |
| `apps_path` (vars) | `/srv/www/apps` | Shared base path consumed by `docker_compose_app`; override if your fleet uses a different root. |

To protect credentials, override the defaults for `KANIDM_ADMIN_PASSWORD` (and other secrets) via an inventory variable or Vault and supply them to the `.env` template.

Dependencies
------------

The role includes `docker_compose_app` internally; any of its requirements (such as ensuring the Docker service is running) must be satisfied beforehand.

Example Playbook
----------------

```yaml
- name: Deploy Kanidm
  hosts: iam_servers
  become: true
  vars:
    kanidm_domain: auth.internal.example.com
    kanidm_tls_generate: false
    kanidm_app_asset_files:
      - src: files/custom.env
        dest: .env
  roles:
    - role: kanidm
```

This example demonstrates overriding the domain, opting out of certificate generation (to supply a trusted cert bundle), and copying a custom `.env` file.

Check Mode
----------

When run with `--check`, the role only reports a reminder and skips directory creation, TLS generation, templating, and Compose deployment. Plan to run it without check mode to perform actual changes.

License
-------

MIT-0

Author Information
------------------

Paul Tibbetts
