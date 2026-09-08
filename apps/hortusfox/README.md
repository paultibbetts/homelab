# HortusFox

HortusFox is available at `https://hortusfox.lab.paultibbetts.uk`.

## Required secret

After Argo CD has created the namespace and chart resources, populate and apply
the ignored `templates/secret.shh.yaml` file:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: hortusfox-env
  namespace: hortusfox
type: Opaque
stringData:
  APP_ADMIN_EMAIL: <initial-admin-email>
  APP_ADMIN_PASSWORD: <initial-admin-password>
  MARIADB_PASSWORD: <database-user-password>
  MARIADB_ROOT_PASSWORD: <database-root-password>
```

The initial admin credentials are used by the container during first startup.
Until this Secret is applied, the HortusFox and MariaDB pods will remain
unavailable because their required credentials are absent.

## Kanidm access

HortusFox uses the shared OAuth2 Proxy service for Kanidm authentication. Only
members of Kanidm's `oauth2_proxy_users` group can reach the application.
HortusFox creates a user account on first sign-in from the verified Kanidm
email and preferred username headers.

Set `APP_ADMIN_EMAIL` to the same email address used by the first Kanidm admin
user before the initial deployment. That user remains the HortusFox admin after
proxy authentication is enabled.
Keep both PVCs when redeploying: `hortusfox-data` holds uploaded content,
backups, themes, logs, and migrations; `mariadb-data` holds the database.
