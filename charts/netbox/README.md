netbox
======

<p align="center">
    <a href="https://opensource.org/licenses/Apache-2.0" alt="Apache 2.0 License">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a href="https://enix.io/fr/blog/" alt="Brought to you by ENIX">
        <img src="https://img.shields.io/badge/Brought%20to%20you%20by-ENIX-%23377dff?labelColor=888&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAQAAAC1QeVaAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfkBAkQIg/iouK/AAABZ0lEQVQY0yXBPU8TYQDA8f/zcu1RSDltKliD0BKNECYZmpjgIAOLiYtubn4EJxI/AImzg3E1+AGcYDIMJA7lxQQQQRAiSSFG2l457+655x4Gfz8B45zwipWJ8rPCQ0g3+p9Pj+AlHxHjnLHAbvPW2+GmLoBN+9/+vNlfGeU2Auokd8Y+VeYk/zk6O2fP9fcO8hGpN/TUbxpiUhJiEorTgy+6hUlU5N1flK+9oIJHiKNCkb5wMyOFw3V9o+zN69o0Exg6ePh4/GKr6s0H72Tc67YsdXbZ5gENNjmigaXbMj0tzEWrZNtqigva5NxjhFP6Wfw1N1pjqpFaZQ7FAY6An6zxTzHs0BGqY/NQSnxSBD6WkDRTf3O0wG2Ztl/7jaQEnGNxZMdy2yET/B2xfGlDagQE1OgRRvL93UOHqhLnesPKqJ4NxLLn2unJgVka/HBpbiIARlHFq1n/cWlMZMne1ZfyD5M/Aa4BiyGSwP4Jl3UAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDQtMDlUMTQ6MzQ6MTUrMDI6MDDBq8/nAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA0LTA5VDE0OjM0OjE1KzAyOjAwsPZ3WwAAAABJRU5ErkJggg==" /></a>
</p>

NetBox is an open source web application designed to help manage and document computer networks.

## TL;DR;

```bash
$ helm repo add enix https://charts.enix.io/
$ helm install my-release enix/netbox
```

Source code can be found [here](https://netbox.readthedocs.io/en/stable/)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | >=8.7.3 |
| https://charts.bitnami.com/bitnami | redis | >=10.6.3 |

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release enix/netbox
```

The command deploys Netbox on the Kubernetes cluster in the default configuration. The [Chart Values](#chart-values) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | affinity configuration on Netbox Pod |
| allowedHosts | string | `"*"` | "ALLOWED_HOSTS" in Netbox configuration |
| deployment.replicaCount | int | `1` | Number of Netbox Pods to run (Deployment mode) |
| emailFrom | string | `nil` | From address of email sent by Netbox |
| emailPassword | string | `""` | Password to use on email server |
| emailPort | int | `25` | SMTP port to use on email server |
| emailServer | string | `nil` | Email server used by Netbox |
| emailTimeout | int | `10` | Timeout in email communications |
| emailUsername | string | `""` | Username to use on email server |
| existingEnvSecret | string | `nil` | Provide secret environment variable. Should contain all netbox's expected secret env vars |
| extraContainers | list | `[]` |  |
| extraEnvs | object | `{}` |  |
| extraInitContainers | list | `[]` |  |
| extraLabels | object | `{}` | Extra labels to add on chart resources |
| extraSecretEnvs | object | `{}` |  |
| extraSecrets | object | `{}` |  |
| extraStartupScripts | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` | String to fully override netbox.fullname template with a string |
| image.pullPolicy | string | `"IfNotPresent"` | Netbox image pull policy |
| image.repository | string | `"netboxcommunity/netbox"` | Netbox image |
| image.tag | string | `nil` | Netbox image version |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Enable ingress controller resource |
| ingress.hosts | list | `["netbox.local"]` | Ingress Hosts |
| ingress.isNginx | bool | `true` | Enable special annotation for Nginx ingress (adds proxy-body-size). See Nginx section. |
| ingress.paths | list | `["/"]` | Ingress Paths |
| ingress.tls | list | `[]` | Ingress TLS |
| initializers | object | `{}` | Netbox initializer file content (mounted in /opt/netbox/initializers/) |
| kind | string | `"StatefulSet"` | Type of deployment (StatefulSet or Deployment) |
| livenessProbe | object | `{"httpGet":{"path":"/api/","port":"http"}}` | livenessProbe configuration on Netbox Pod |
| nameOverride | string | `""` | String to partially override netbox.fullname template with a string (will prepend the release name) |
| nginx.customConfig | string | `nil` | Custom nginx configuration |
| nginx.proxyBodySize | string | `nil` | See: http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size |
| nginx.proxyPass | string | `"http://localhost:8001"` | Custom proxypass url |
| nginxImage.pullPolicy | string | `"IfNotPresent"` | Nginx image pull policy |
| nginxImage.repository | string | `"nginx"` | Nginx image |
| nginxImage.tag | string | `"1.17.9-alpine"` | Nginx image version |
| nodeSelector | object | `{}` | nodeSelector configuration on Netbox Pod |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Persistent Volume Access Modes. Only for statefulSet Mode |
| persistence.customVolumeClaims | string | `nil` | Entirely customize VolumeClaims. Only for statefulSet Mode |
| persistence.enabled | bool | `true` | Enable statefulSet persistency |
| persistence.size | string | `"5G"` | Size of data volume. Only for statefulSet Mode |
| persistence.storageClassName | string | `nil` | Storage class of backing PVC. Only for statefulSet Mode |
| postgresql.enabled | bool | `true` | Enable the postgresql sub-chart |
| postgresql.host | string | `nil` | Host of the postgresql server to use |
| postgresql.postgresqlDatabase | string | `"netbox"` | Postgresql database name |
| postgresql.postgresqlPassword | string | `"netbox"` | Postgresql password (DO NOT USE DEFAULT VALUE IN PRODUCTION) |
| postgresql.postgresqlUsername | string | `"netbox"` | Postgresql username |
| readinessProbe | object | `{"httpGet":{"path":"/api/","port":"http"}}` | readinessProbe configuration on Netbox Pod |
| redis.cluster.enabled | bool | `false` | Enable the redis sub-chart cluster-mode |
| redis.enabled | bool | `true` | Enable the redis sub-chart |
| redis.host | string | `nil` | Host of the redis server |
| redis.master.persistence.enabled | bool | `false` |  |
| resources | object | `{}` | resources configuration on Netbox Pod |
| restartPolicy | string | `"Always"` | Pods restart policy |
| secretKey | string | `nil` | Netbox django secret key (use long random string) |
| service.port | int | `80` | Port to use to access Netbox |
| service.type | string | `"ClusterIP"` | Kubernetes Service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `nil` | Name of the service account to use. Default is derived from fullname template |
| statefulSet.replicaCount | int | `1` | Number of Netbox Pods to run (StatefulSet mode) |
| superuser.apiToken | string | `nil` | API access token of the Netbox superuser to create on first launch |
| superuser.email | string | `"admin@example.com"` | Email of the Netbox superuser to create on first launch |
| superuser.name | string | `"admin"` | Username of the Netbox superuser to create on first launch |
| superuser.password | string | `nil` | Password of the Netbox superuser to create on first launch |
| superuserExistingSecret | string | `nil` | Use custom secret for initial superuser credentials. Should contain appropriate environment variable name (eg: SUPERUSER_PASSWORD) |
| superuserSkip | bool | `false` | Don't create superuser on startup. |
| tolerations | list | `[]` | tolerations to add on Netbox Pod |
| updateStrategy | object | `{"type":"RollingUpdate"}` | Update strategy policy |

## License

Copyright (c) 2020 ENIX

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.