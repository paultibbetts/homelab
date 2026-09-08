# OAuth2 Proxy

OAuth2 Proxy is the shared Kanidm-backed authentication service for applications
in this cluster. It is available at `https://oauth2-proxy.lab.paultibbetts.uk`.

## Initial setup

1. Run [`kanidm-oauth2-proxy.sh`](../../kanidm-oauth2-proxy.sh) to create the
   Kanidm client and its `oauth2_proxy_users` access group.
2. Add the intended users to that group.
3. After Argo CD creates the `oauth2-proxy` namespace and chart resources,
   populate and apply the ignored `templates/secret.shh.yaml` file.

The Kanidm OAuth client redirect URI must remain:

```
https://oauth2-proxy.lab.paultibbetts.uk/oauth2/callback
```

The proxy uses a shared, HTTPS-only cookie for `.lab.paultibbetts.uk`. No
applications use it until a Traefik ForwardAuth middleware is attached to their
IngressRoute.
