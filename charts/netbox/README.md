netbox
======
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
| image.tag | string | `"v2.7.12"` | Netbox image version |
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
| persistence.enabled | bool | `true` | Enable persistency (Deployment mode) |
| postgresql.enabled | bool | `true` | Enable the postgresql sub-chart |
| postgresql.host | string | `nil` | Host of the postgresql server to use |
| postgresql.postgresqlDatabase | string | `"netbox"` | Postgresql database name |
| postgresql.postgresqlPassword | string | `"netbox"` | Postgresql password (DO NOT USE DEFAULT VALUE IN PRODUCTION) |
| postgresql.postgresqlUsername | string | `"netbox"` | Postgresql username |
| readinessProbe | object | `{"httpGet":{"path":"/api/","port":"http"}}` | readinessProbe configuration on Netbox Pod |
| redis.cluster.enabled | bool | `false` | Enable the redis sub-chart cluster-mode |
| redis.enabled | bool | `true` | Enable the redis sub-chart |
| redis.host | string | `nil` | Host of the redis server |
| resources | object | `{}` | resources configuration on Netbox Pod |
| restartPolicy | string | `"Always"` | Pods restart policy |
| secretKey | string | `nil` | Netbox django secret key (use long random string) |
| service.port | int | `80` | Port to use to access Netbox |
| service.type | string | `"ClusterIP"` | Kubernetes Service type |
| statefulSet.persistence.accessModes | list | `["ReadWriteOnce"]` | Persistent Volume Access Modes |
| statefulSet.persistence.enabled | bool | `true` | Enable statefulSet persistency |
| statefulSet.persistence.size | string | `"5G"` | Size of data volume |
| statefulSet.persistence.storageClassName | string | `nil` | Storage class of backing PVC |
| statefulSet.replicaCount | int | `1` | Number of Netbox Pods to run (StatefulSet mode) |
| statefulSet.updateStrategy | object | `{"type":"RollingUpdate"}` | Update strategy policy |
| superuser.email | string | `"admin@example.com"` | Email of the Netbox superuser to create on first launch |
| superuser.name | string | `"admin"` | Username of the Netbox superuser to create on first launch |
| superuser.password | string | `nil` | Password of the Netbox superuser to create on first launch |
| superuser.token | string | `nil` | API access token of the Netbox superuser to create on first launch |
| tolerations | list | `[]` | tolerations to add on Netbox Pod |
