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

## Notes
* Subnets are defined manually, as kubernetes by default picks public subnets only. As our infra is on private so we need private subnets also.
* Sops should be used, credentials shouldnt be on plain text
* Mysql pod is just for debugging purpose