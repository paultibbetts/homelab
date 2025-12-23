Newt
=========

Installs the Newt binary and wires it into a systemd service using a small
wrapper script and an environment file for credentials.

Requirements
------------

- Debian-family host (Ubuntu/Debian) on x86_64/amd64.
- systemd available (the role installs a unit under `/etc/systemd/system`).

Role Variables
--------------

Defaults in `defaults/main.yml`:

- `newt_repo`: GitHub repo that hosts Newt releases. Default: `fosrl/newt`.
- `newt_version`: Release tag to install. Default: `1.8.0`.
- `newt_bin_path`: Install path for the Newt binary. Default: `/usr/local/bin/newt`.
- `newt_wrapper_path`: Wrapper script path. Default: `/usr/local/bin/newt-run`.
- `newt_service_name`: systemd unit name. Default: `newt`.
- `newt_env_file`: Environment file path. Default: `/etc/default/newt`.

Required vars you need to set:

- `newt_endpoint`: Newt endpoint URL.
- `newt_id`: Newt ID.
- `newt_secret`: Newt secret.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: newt_hosts
      roles:
        - role: newt
          vars:
            newt_endpoint: "https://app.pangolin.net"
            newt_id: "{{ vault_newt_id }}"
            newt_secret: "{{ vault_newt_secret }}"

License
-------

MIT

Author Information
------------------

Paul Tibbetts
