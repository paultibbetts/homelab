DDNS Role
=========

Installs a DuckDNS updater by templating a small shell script and scheduling it via cron. The role ensures `curl` is present, writes the update script, and runs it every hour to keep the public DNS record current.

Requirements
------------

- A Debian/Ubuntu host with `apt` and cron available.
- A DuckDNS token supplied via inventory or Vault.

Role Variables
--------------

Defaults live under `defaults/main.yml` unless noted.

| Variable | Default | Description |
| --- | --- | --- |
| `ddns_script` | `/root/duck.sh` | Path where the DuckDNS update script is written. |
| `duckdns_token` | `unset` | API token for the DuckDNS account (supply via inventory or Vault). |

The DuckDNS domain name is currently defined in `templates/duck.sh.j2`. Update the template (or replace it with your own) to target different domains.

Dependencies
------------

None.

Example Playbook
----------------

```yaml
- name: Configure DuckDNS updates
  hosts: edge
  become: true
  vars:
    duckdns_token: "{{ vault_duckdns_token }}"
    ddns_script: /usr/local/bin/duckdns-update
  roles:
    - role: ddns
```

This example stores the token in Vault and installs the script outside of `/root`.

License
-------

MIT-0

Author Information
------------------

Paul Tibbetts
