# Grocy-Mealie Sync

Synchronises Grocy inventory with Mealie foods and shopping-list items. It is
available at `https://grocy-mealie-sync.lab.paultibbetts.uk` and uses
`ghcr.io/harmellis/grocy-mealie-sync:1.14.2`.

The persistent claim `grocy-mealie-sync-data` stores `/app/data/sync.db`. Keep
that PVC when disabling or redeploying the app: it contains all product and
unit mappings, sync state, and the scheduler locks. Losing it loses that state.

## Required secret

Create the ignored file `templates/secret.shh.yaml` before the app is synced,
using the same local-secret convention as the other apps:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: grocy-mealie-sync-env
  namespace: grocy-mealie-sync
type: Opaque
stringData:
  GROCY_API_KEY: <dedicated Grocy API key>
  MEALIE_API_TOKEN: <dedicated Mealie API token>
  AUTH_SECRET: <long random secret for the sync UI>
```

Create the Grocy key at **Settings → Manage API keys → Add**. Create the
Mealie token at **User Settings → API Tokens → Create Token**. `AUTH_SECRET`
is the password for the sync UI and bearer token for its protected API routes.
Do not commit this file.

## Initial safety settings

The deployment locks these settings with environment variables:

- Product creation in Grocy: disabled.
- Quantity-unit creation in Grocy: disabled.
- Active low-stock enforcement on the Mealie list: disabled.
- Mealie `In possession` sync: disabled.
- Checked-item cleanup: disabled.
- MCP: disabled.
- Insecure outbound TLS: disabled.
- Restocking only applies to Grocy products with a positive minimum stock.

The Mealie shopping-list ID and Grocy default unit are intentionally unset so
they can be selected in the UI. To change any locked setting later, remove its
environment variable from `templates/deployment.yaml`; environment variables
override and lock the corresponding UI setting.

There is no upstream global scheduler pause or dry-run mode. On startup and
every six hours, the app will name-match Grocy products/units with Mealie and
persist mappings; with automatic creation disabled it will not create missing
Grocy products or units. With no Mealie shopping-list ID configured, both
scheduled shopping-list directions skip. After a list is selected, a newly
checked mapped item can create a Grocy purchase (subject to
`STOCK_ONLY_MIN_STOCK=true`), so select a list only after reviewing mappings.

## First run

1. Back up Mealie.
2. Create dedicated Grocy and Mealie credentials.
3. Populate `templates/secret.shh.yaml` with the three required keys.
4. Let Argo CD deploy the application and sign in using `AUTH_SECRET`.
5. Confirm the locked safety settings in the UI.
6. Review unit mappings, then product mappings.
7. Use the Mapping Wizard on a small subset first.
8. Choose the intended Mealie shopping list only after reviewing mappings.
9. Test one deliberately low-risk product and verify both systems before
   expanding use.

Use the Mapping Wizard from the web UI. Verify health with
`GET /api/health`; inspect runtime activity with
`kubectl -n grocy-mealie-sync logs deployment/grocy-mealie-sync`. To disable
the service safely, commit `replicas: 0` in `templates/deployment.yaml` and
sync Argo CD. This preserves `grocy-mealie-sync-data`; deleting the app would
allow Argo CD pruning to delete the PVC and its sync state.
