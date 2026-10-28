# Soundbored

Soundbored is a self-hosted Discord soundboard. This chart uses the pinned
upstream image `christom/soundbored:d0a869ce46a9d9217852c6087464d021f6685011`
and stores uploaded audio and its SQLite database on separate PVCs.

It is available at `https://soundbored.lab.paultibbetts.uk`. The deployment
sets `PHX_HOST` and `SCHEME` to this URL, so the Discord OAuth callback must
also use this hostname. It intentionally does not configure a public hostname.

## Required secret

Before Argo CD syncs this chart, create the ignored local file
`templates/secret.shh.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: soundbored-env
  namespace: soundbored
type: Opaque
stringData:
  DISCORD_TOKEN: <Discord bot token>
  DISCORD_CLIENT_ID: <Discord application ID>
  DISCORD_CLIENT_SECRET: <Discord OAuth client secret>
  SECRET_KEY_BASE: <output of openssl rand -base64 48>
  DISCORD_REQUIRED_GUILD_ID: "695005465247219762"
  DISCORD_REQUIRED_ROLE_IDS: "1564953070532567101"
```

`templates/secret.shh.yaml` is excluded by the repository-wide `*.shh.yaml`
rule and must never be committed. Soundbored permits sign-in only when the
Discord user is a member of guild `695005465247219762` and has role
`1564953070532567101`. The bot must be a member of that guild. This makes
Soundbored's optional Basic Auth unnecessary for the initial private setup.

## Deployment

Commit and push the chart, then create the namespace and apply the local
secret before Argo CD syncs the app:

```sh
kubectl create namespace soundbored
kubectl -n soundbored apply -f apps/soundbored/templates/secret.shh.yaml
```

Argo CD's apps ApplicationSet discovers `apps/soundbored` automatically. Check
the result with:

```sh
kubectl -n soundbored get pods,pvc,secret
kubectl -n soundbored logs deployment/soundbored --follow
```

The Discord app must be configured before the pod can provide its full bot and
login functionality. The next step is to register its exact callback URL:
`https://soundbored.lab.paultibbetts.uk/auth/discord/callback`, enable the
required Discord intents, and invite the bot. That can be done after these
manifests are in Git; the pod will not start until the required Secret exists.
