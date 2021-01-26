# configmap2http

![Version: 3737](https://img.shields.io/badge/Version-3737-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3737](https://img.shields.io/badge/AppVersion-3737-informational?style=flat-square)

expose a configmap through an ingress

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configMap | string | `"public"` |  |
| ingress.class | string | `nil` |  |
| ingress.hostname | string | `nil` |  |

