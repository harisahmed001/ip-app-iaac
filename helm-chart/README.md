# Ip App

This application saves the ip on mysql and fetch from table on list page.

## Run

Helm Plugins
```bash
helm plugin install https://github.com/databus23/helm-diff
helm plugin install https://github.com/jkroepke/helm-secrets
```

Chart Install
```bash
helm upgrade --install ipapp ./ --wait
```
