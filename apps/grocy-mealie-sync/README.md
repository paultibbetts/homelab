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

## Product model

Mealie contains generic recipe ingredients. Grocy holds the actual purchasable
products and their stock.

```text
Mealie food
└── Cider vinegar

Grocy product hierarchy
Cider vinegar
└── Osu cider vinegar — 500 ml
```

Set up the generic Grocy parent, `Cider vinegar`, as follows:

- Map it to Mealie `Cider vinegar`.
- Do not purchase or record direct stock against it.
- Set its minimum stock to `0` initially.
- Leave Grocy's **Own stock** enabled. Although the parent holds no direct
  stock, grocy-mealie-sync v1.14.2 skips `In possession` updates for products
  with Own stock disabled. With Own stock enabled, it reads Grocy's aggregated
  stock, so its children count toward the mapped Mealie food.

Set up `Osu cider vinegar — 500 ml` as a child of `Cider vinegar`:

- Record its barcode, purchases, real stock, and expiry dates on the child.
- Use `bottle` as its purchase unit and preferably `ml` as its stock unit.
- Add the product-specific conversion `1 bottle = 500 ml`.
- Set its minimum stock to `0` initially.

Do not map Mealie directly to the branded child. A checked Mealie item only
identifies the generic food; it does not identify the brand bought.

The intended shopping workflow is:

1. A recipe adds generic `Cider vinegar` to the Mealie shopping list.
2. Choose any suitable brand in the shop and check the Mealie item off for
   shopping-list purposes.
3. The mapped Grocy parent has minimum stock `0`, so
   `STOCK_ONLY_MIN_STOCK=true` prevents the sync from purchasing generic stock.
4. Separately scan or purchase the actual branded Grocy child.
5. Grocy records one Osu bottle as 500 ml, and the parent's aggregated stock
   becomes positive.
6. The sync marks Mealie `Cider vinegar` as `In possession`.

## Environment-controlled settings

The deployment locks these settings with environment variables:

- Product creation in Grocy: disabled.
- Quantity-unit creation in Grocy: temporarily enabled to bootstrap Mealie
  units into Grocy. Review all mappings (especially aliases such as `g`/`gram`
  and `ml`/`millilitre`) in the Mapping Wizard, then change
  `AUTO_CREATE_UNITS` to `false`.
- Active low-stock enforcement on the Mealie list: disabled.
- Mealie `In possession` sync: enabled for any positive aggregated stock.
- Sub-product-to-parent shopping-list sync: disabled.
- Parent-own-stock low-stock tracking: disabled.
- Checked-item cleanup: disabled.
- Cleanup mode: `synced_only` as a defensive default if cleanup is enabled
  later.
- MCP: disabled.
- Insecure outbound TLS: disabled.
- Restocking only applies to Grocy products with a positive minimum stock.
- The Mapping Wizard accepts minimum-stock increments of `0.1`.

The Grocy default unit is intentionally unset because automatic product
creation is disabled. `MEALIE_SHOPPING_LIST_ID` is intentionally absent from
the manifest, preserving the existing UI-selected dedicated list. If it needs
to be recreated, select the list in the UI rather than adding an invented UUID.

Every setting listed above that is represented by an environment variable is
locked in the UI. Change or remove its entry in `templates/deployment.yaml` to
change it later. Connection, authentication, timezone, database, polling, MCP,
and TLS variables are also environment controlled, but are not normal UI
settings. Stale-lock recovery is an operational UI/API action, not an
environment setting.

There is no upstream global scheduler pause or dry-run mode. On startup and
every six hours, the app name-matches Grocy products/units with Mealie and
persists mappings. Product creation remains disabled, but unit creation is
temporarily enabled as described above.

When a checked Mealie item is mapped to a Grocy parent with
`min_stock_amount = 0`, `STOCK_ONLY_MIN_STOCK=true` skips it. The app still
records that item as checked, but not as synced to Grocy. It will not be
restocked retrospectively merely because the parent minimum is later raised;
uncheck and re-check it to create a new event. `synced_only` cleanup would also
leave this skipped item alone. If Grocy cannot read the parent details during
the minimum-stock check, upstream logs a warning and proceeds with a purchase,
so monitor sync logs while testing.

## First run

1. Back up Mealie.
2. Create dedicated Grocy and Mealie credentials.
3. Populate `templates/secret.shh.yaml` with the three required keys.
4. Let Argo CD deploy the application and sign in using `AUTH_SECRET`.
5. Confirm the locked safety settings in the UI.
6. Review unit mappings, then product mappings.
7. Use the Mapping Wizard on a small subset first.
8. Confirm the intended Mealie shopping list remains selected after deploying
   this configuration.
9. Test one deliberately low-risk generic parent and branded child, then verify
   both systems before
   expanding use.

Use the Mapping Wizard from the web UI. Verify health with
`GET /api/health`; inspect runtime activity with
`kubectl -n grocy-mealie-sync logs deployment/grocy-mealie-sync`. To disable
the service safely, commit `replicas: 0` in `templates/deployment.yaml` and
sync Argo CD. This preserves `grocy-mealie-sync-data`; deleting the app would
allow Argo CD pruning to delete the PVC and its sync state.
