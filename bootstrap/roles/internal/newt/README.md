# Newt

Installs the Newt binary and wires it into a systemd service using a small
wrapper script and an environment file for credentials.

## Requirements

- Debian-family host (Ubuntu/Debian) on x86_64/amd64.
- systemd available (the role installs a unit under `/etc/systemd/system`).

## Role Variables

Defaults in `defaults/main.yml`:

- `newt_repo`: GitHub repo that hosts Newt releases. Default: `fosrl/newt`.
- `newt_version`: Release tag to install. Default: `1.8.0`.
- `newt_bin_path`: Install path for the Newt binary. Default: `/usr/local/bin/newt`.
- `newt_wrapper_path`: Wrapper script path. Default: `/usr/local/bin/newt-run`.
- `newt_service_name`: systemd unit name. Default: `newt`.
- `newt_env_file`: Environment file path. Default: `/etc/default/newt`.

Blueprint support (optional):

- `newt_blueprint`: A Pangolin Blueprint object that Newt will apply when started with `--blueprint-file`.
- `newt_blueprint_mode`: When using split blueprints, select `auth-only` or `full`. Default: `full`.
- `newt_blueprint_auth_only`: Minimal blueprint (typically used to expose only the IdP/auth resource).
- `newt_blueprint_full`: Full blueprint (all resources).
- `newt_blueprint_path`: Where to write the blueprint file on the host. Default: `/etc/pangolin/blueprint.yaml`.

Required vars you need to set:

- `newt_endpoint`: Newt endpoint URL.
- `newt_id`: Newt ID.
- `newt_secret`: Newt secret.

## Dependencies

An instance of Pangolin set up and a site added.

The (optional) blueprint support requires the blueprint to have the ID of the site name set.

## Example Playbook

    - hosts: newt_hosts
      roles:
        - role: newt
          vars:
            newt_endpoint: "https://app.pangolin.net"
            newt_id: "{{ vault_newt_id }}"
            newt_secret: "{{ vault_newt_secret }}"

I use Pangolin to expose my IdP that I then use for SSO to secure access to resources.

Because of this I first apply a blueprint that only exposes the auth:

    - hosts: newt_hosts
      roles:
        - role: newt
      vars:
        newt_endpoint: "https://app.pangolin.net"
        newt_id: "{{ vault_newt_id }}"
        newt_secret: "{{ vault_newt_secret }}"
        newt_blueprint_mode: "auth-only"
        newt_blueprint_auth_only:
          public-resources:
            auth:
              name: "Auth"
              protocol: http
              full-domain: "auth.example.com"
              targets:
                - site: "home" # this must match the ID of the site
                  hostname: "192.168.1.10"
                  method: http
                  port: 8080

after which I register the IdP in Pangolin to use for SSO and then apply the full blueprint.

The following example uses YAML anchors and so should be placed in `group_vars` or `host_vars` in a `.yaml` file.

I use Ansible Vault to encrypt my blueprint in a `vault.yaml` file to avoid exposing my tunneled resources in my public git repo.

    # Example `group_vars` snippet showing split blueprints.
    #
    # - `newt_blueprint_auth_only` exposes the IdP resource (no SSO).
    # - `newt_blueprint_full` exposes the IdP resource plus an example app secured by SSO.
    #
    # The `auto-login-idp: 1` assumes you've registered your IdP in Pangolin and its ID is `1`.

    newt_site_name: &newt_site_name "home"

    newt_blueprint_auth_resource: &newt_blueprint_auth_resource
      name: "Auth"
      protocol: http
      full-domain: "auth.example.com"
      tls-server-name: "auth.example.com"
      targets:
        - site: *newt_site_name
          hostname: "auth.internal.example"
          method: http
          port: 8080

    newt_blueprint_auth_only:
      public-resources:
        auth: *newt_blueprint_auth_resource

    newt_blueprint_full:
      public-resources:
        auth: *newt_blueprint_auth_resource
        app:
          name: "Example App"
          protocol: http
          full-domain: "app.example.com"
          tls-server-name: "app.example.com"
          auth:
            sso-enabled: true
            sso-roles:
              - Member
            auto-login-idp: 1
          rules:
            - action: pass
              match: country
              value: GB
            - action: deny
              match: country
              value: ALL
          targets:
            - site: *newt_site_name
              hostname: "192.0.2.10"
              method: http
              port: 8080
              healthcheck:
                hostname: "192.0.2.10"
                port: 8080
                enabled: true
                path: /
                interval: 30
                timeout: 5
                method: GET
                status: 200

## License

MIT

## Author Information

Paul Tibbetts

## Notes

The custom blueprint stuff is not standard and is only because I expose my IDP via Newt and then register it with Pangolin before applying the full blueprint with all the resources in.
