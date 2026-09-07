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
Keep both PVCs when redeploying: `hortusfox-data` holds uploaded content,
backups, themes, logs, and migrations; `mariadb-data` holds the database.
