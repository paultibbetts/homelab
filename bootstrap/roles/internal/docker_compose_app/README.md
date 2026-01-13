# docker_compose_app

Reusable helper role that stages a Docker Compose application from another role's assets, renders an optional `.env` template, and starts the stack with `docker compose`.

## Requirements

- Docker Engine and Compose V2 available on the target host (e.g. via `geerlingguy.docker`).
- The role that owns the Compose assets provides its files under `files/` and `templates/`. The helper auto-detects the caller's `role_path`, but you can override it with `src_role_path` if needed.

## Role Variables

- `app_name` *(optional)*: Used as the Compose project name.
- `app_path` **(required)**: Destination directory on the target host (e.g. `/srv/apps/my-app`).
- `src_role_path` *(optional)*: Path to the role that ships the Compose assets. Automatically falls back to the including role's `role_path`, but can be overridden when assets live elsewhere.
- `compose_src` *(optional)*: Override path to the Compose file. Defaults to `<src_role_path>/files/docker-compose.yaml`.
- `env_template` *(optional)*: Override path to the `.env` template. Defaults to `<src_role_path>/templates/.env.j2` and is skipped if the file is absent.
- `app_asset_dirs` *(optional, default: `["static", "config", "tls", "files"]`)*: Directories under `<src_role_path>/files/` to copy recursively when present.
- `app_asset_files` *(optional)*: Individual files under `<src_role_path>/files/` to copy verbatim.
- `down_before_up` *(optional, default: `false`)*: Run `docker compose down` before bringing the stack back up.

## Example

```yaml
- name: Deploy Kanidm
  ansible.builtin.include_role:
    name: docker_compose_app
  vars:
    app_name: "{{ kanidm_app_name }}"
    app_path: "{{ kanidm_app_path }}"
    app_asset_dirs: ["static"]
```

Place your `docker-compose.yaml`, `.env.j2`, and any additional directories/files in the calling role's `files/` and `templates/` folders.
