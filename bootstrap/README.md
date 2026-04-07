# Bootstrap

This repo bootstraps Argo CD in two steps:

1. Render and apply Argo CD itself from [`argocd`](./argocd), using the minimal seed values in [`argocd/values-seed.yaml`](./argocd/values-seed.yaml).
2. Render and apply the Argo CD seeding chart from [`cluster`](./cluster). This creates the `AppProject` and `ApplicationSet` resources that point Argo CD back at this repo.

After that, Argo CD manages the apps in `bootstrap/`, including Argo CD itself.

##

```sh
./bootstrap/init.sh
``
```
