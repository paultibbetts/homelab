# docker_compose_app

Deprecated wrapper. Use `roles/internal/common/tasks/deploy_compose_app.yml` via `include_tasks` and
pass explicit `app_name`, `app_path`, and `compose_src` instead.

Reusable helper role that stages a Docker Compose application from another role's assets, renders an optional `.env` template, and starts the stack with `docker compose`.

## Requirements

- Docker Engine and Compose V2 available on the target host (e.g. via `geerlingguy.docker`).

## Role Variables

- `app_name` **(required)**: Used as the Compose project name.
- `app_path` **(required)**: Destination directory on the target host (e.g. `/srv/apps/my-app`).
- `compose_src` **(required)**: Path to the Compose file to copy to the target host.
- `env_template` *(optional)*: Path to a `.env` template to render.
- `app_user` / `app_group` *(optional)*: Runtime user/group; default to the Ansible user.
- `volume_dirs` *(optional)*: List of bind mount root directories to ensure exist and are owned.
- `enforce_volume_ownership` *(optional)*: When true, recursively chown `volume_dirs` post-compose.

## Example

```yaml
- name: Deploy Kanidm (deprecated wrapper)
  ansible.builtin.include_role:
    name: docker_compose_app
  vars:
    app_name: "{{ kanidm_app_name }}"
    app_path: "{{ kanidm_app_path }}"
    compose_src: "{{ role_path }}/files/docker-compose.yaml"
```

Place your `docker-compose.yaml`, `.env.j2`, and any additional directories/files in the calling role's `files/` and `templates/` folders.
