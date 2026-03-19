# Caddy Role

Installs and configures [Caddy](https://caddyserver.com/) as a systemd service. The role downloads a custom Caddy build (Cloudflare DNS plugin), creates a dedicated user/group, renders the unit file and Caddyfile, and enables the service.

## Requirements

- Systemd on the target host.
- Network access from the target host to download the Caddy binary when it is not already installed.
- Provide `caddy_env_vars` with `CF_API_TOKEN=...` if the Caddyfile uses the Cloudflare DNS challenge.

## Role Variables

Defaults live under `defaults/main.yml`; `caddy_env_vars` should be supplied via inventory or group vars when needed.

| Variable                    | Default                                                                                          | Description                                                                                                         |
| --------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| `caddy_bin_path`            | `/usr/local/bin/caddy`                                                                           | Destination for the downloaded Caddy binary.                                                                        |
| `caddy_download_url`        | `https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fcaddy-dns%2Fcloudflare` | URL used to fetch a custom Caddy build.                                                                             |
| `caddy_group_name`          | `caddy`                                                                                          | System group for the Caddy service.                                                                                 |
| `caddy_user_name`           | `caddy`                                                                                          | System user for the Caddy service.                                                                                  |
| `caddy_user_home_directory` | `/var/lib/caddy`                                                                                 | Home directory for the Caddy service account.                                                                       |
| `caddy_config_path`         | `/etc/caddy`                                                                                     | Directory where the Caddyfile is rendered.                                                                          |
| `caddy_log_path`            | `/var/log/caddy`                                                                                 | Directory for Caddy logs (ownership set to the Caddy user).                                                         |
| `caddy_env_vars`            | `unset`                                                                                          | List of `KEY=value` strings added as systemd `Environment=` entries (define `CF_API_TOKEN=...` for Cloudflare DNS). |

Update `templates/Caddyfile.j2` with your desired sites and upstreams; the role renders it to `{{ caddy_config_path }}/Caddyfile`.

## Dependencies

None.

## Example Playbook

```yaml
- name: Deploy Caddy
  hosts: edge
  become: true
  vars:
    caddy_env_vars:
      - CF_API_TOKEN=super-secret
  roles:
    - role: caddy
```

This example provides the Cloudflare API token used by the DNS challenge in the default Caddyfile template.

## License

MIT-0

## Author Information

Paul Tibbetts
