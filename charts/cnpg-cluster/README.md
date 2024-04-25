# cnpg-cluster

[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/enix)](https://artifacthub.io/packages/search?repo=enix)
<p align="center">
    <a href="https://opensource.org/licenses/Apache-2.0" alt="Apache 2.0 License">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a href="https://enix.io/fr/blog/" alt="Brought to you by ENIX">
        <img src="https://img.shields.io/badge/Brought%20to%20you%20by-ENIX-%23377dff?labelColor=888&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAQAAAC1QeVaAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfkBAkQIg/iouK/AAABZ0lEQVQY0yXBPU8TYQDA8f/zcu1RSDltKliD0BKNECYZmpjgIAOLiYtubn4EJxI/AImzg3E1+AGcYDIMJA7lxQQQQRAiSSFG2l457+655x4Gfz8B45zwipWJ8rPCQ0g3+p9Pj+AlHxHjnLHAbvPW2+GmLoBN+9/+vNlfGeU2Auokd8Y+VeYk/zk6O2fP9fcO8hGpN/TUbxpiUhJiEorTgy+6hUlU5N1flK+9oIJHiKNCkb5wMyOFw3V9o+zN69o0Exg6ePh4/GKr6s0H72Tc67YsdXbZ5gENNjmigaXbMj0tzEWrZNtqigva5NxjhFP6Wfw1N1pjqpFaZQ7FAY6An6zxTzHs0BGqY/NQSnxSBD6WkDRTf3O0wG2Ztl/7jaQEnGNxZMdy2yET/B2xfGlDagQE1OgRRvL93UOHqhLnesPKqJ4NxLLn2unJgVka/HBpbiIARlHFq1n/cWlMZMne1ZfyD5M/Aa4BiyGSwP4Jl3UAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDQtMDlUMTQ6MzQ6MTUrMDI6MDDBq8/nAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA0LTA5VDE0OjM0OjE1KzAyOjAwsPZ3WwAAAABJRU5ErkJggg==" /></a>
</p>

A Helm chart to create cloudnative-pg.io clusters

## TL;DR;

```bash
$ helm repo add enix https://charts.enix.io/
$ helm install my-release enix/cnpg-cluster
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release enix/cnpg-cluster
```

The command deploys a CNPG cluster on the Kubernetes cluster in the default configuration. The [Chart Values](#chart-values) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup.azureCredentials | object | `nil` | The credentials to use to upload data to Azure Blob Storage See: https://cloudnative-pg.io/documentation/1.17/api_reference/#AzureCredentials |
| backup.createSecret | bool | `false` | Enable the secret creation for the backup credentials |
| backup.data | object | `{}` | Configuration of the backup of the data directory See: https://cloudnative-pg.io/documentation/1.17/api_reference/#DataBackupConfiguration |
| backup.destinationPath | string | `""` | The path where to store the backup (i.e. s3://bucket/path/to/folder) this path, with different destination folders, will be used for WALs and for data -- |
| backup.enabled | bool | `false` | Enable backups |
| backup.endpointCA | string | `nil` | EndpointCA store the CA bundle of the barman endpoint. Useful when using self-signed certificates to avoid errors with certificate issuer and barman-cloud-wal-archive |
| backup.endpointURL | string | `nil` | Endpoint to be used to upload data to the cloud, overriding the automatic endpoint discovery |
| backup.googleCredentials | object | `nil` | The credentials to use to upload data to Google Cloud Storage See: https://cloudnative-pg.io/documentation/1.17/api_reference/#GoogleCredentials |
| backup.historyTags | object | `{}` |  |
| backup.retentionPolicy | string | `"30d"` | RetentionPolicy is the retention policy to be used for backups and WALs (i.e. '60d'). The retention policy is expressed in the form of XXu where XX is a positive integer and u is in [dwm] - days, weeks, months. |
| backup.s3Credentials | object | `nil` | The credentials to use to upload data to S3 See: https://cloudnative-pg.io/documentation/1.17/api_reference/#S3Credentials |
| backup.secretName | string | `nil` | Override secret name for the backup credentials |
| backup.serverName | string | `nil` | The server name on S3, the cluster name is used if this parameter is omitted |
| backup.tags | object | `{}` |  |
| backup.volumeSnapshot | object | `{}` | The configuration for the execution of volume snapshot backups. See: https://cloudnative-pg.io/documentation/1.22/cloudnative-pg.v1/#postgresql-cnpg-io-v1-VolumeSnapshotConfiguration |
| backup.wal | object | `{}` | Configuration of the backup of the WAL stream See: https://cloudnative-pg.io/documentation/1.17/api_reference/#walbackupconfiguration |
| clusterExtraSpec | object | `{}` | Extra configuration for Cluster resource. See: https://cloudnative-pg.io/documentation/1.17/api_reference/#clusterspec |
| customServices | object | `{"any":{"annotations":{},"enabled":false,"externalIPs":[],"type":"ClusterIP"},"r":{"annotations":{},"enabled":false,"externalIPs":[],"type":"ClusterIP"},"ro":{"annotations":{},"enabled":false,"externalIPs":[],"type":"ClusterIP"},"rw":{"annotations":{},"enabled":false,"externalIPs":[],"type":"ClusterIP"}}` | Custom services to create |
| customServices.any | object | `{"annotations":{},"enabled":false,"externalIPs":[],"type":"ClusterIP"}` | Custom services for any member |
| customServices.r | object | `{"annotations":{},"enabled":false,"externalIPs":[],"type":"ClusterIP"}` | Custom services for readable members |
| customServices.ro | object | `{"annotations":{},"enabled":false,"externalIPs":[],"type":"ClusterIP"}` | Custom services for read-only (replicas) members |
| customServices.rw | object | `{"annotations":{},"enabled":false,"externalIPs":[],"type":"ClusterIP"}` | Custom services for read-write (primary) member |
| extraAffinity | object | `{}` | Extra configuration for Cluster's affinity resource, see: https://cloudnative-pg.io/documentation/1.17/api_reference/#AffinityConfiguration |
| fullnameOverride | string | `""` | String to fully override cnpg-cluster.fullname template with a string |
| image.pullPolicy | string | `"IfNotPresent"` | Postgres image pull policy |
| image.repository | string | `"ghcr.io/cloudnative-pg/postgresql"` | Postgres image repository. Keep empty to use operator's default image. See: https://cloudnative-pg.io/documentation/1.17/operator_capability_levels/#override-of-operand-images-through-the-crd |
| image.tag | string | `""` | Override the Postgres image tag |
| imagePullSecrets | list | `[]` | Docker-registry secret names as an array |
| nameOverride | string | `""` | String to partially override cnpg-cluster.fullname template with a string (will prepend the release name) |
| nodeSelector | object | `{}` | Postgres instances labels for pod assignment |
| persistence.pvcTemplate | object | `{}` | Template to be used to generate the Persistent Volume Claim |
| persistence.resizeInUseVolumes | string | `nil` | Resize existent PVCs, defaults to true	 |
| persistence.size | string | `"1Gi"` | Size of each instance storage volume |
| persistence.storageClass | string | `""` | StorageClass to use for database data, Applied after evaluating the PVC template, if available. If not specified, generated PVCs will be satisfied by the default storage class |
| poolers | object | `{}` | Poller resources to create for this Cluster resource See: https://cloudnative-pg.io/documentation/1.17/api_reference/#PoolerSpec |
| registryCredentials | string | `nil` | Create a docker-registry secret and use it as imagePullSecrets |
| replicaCount | int | `1` | Number of Postgres instances in the cluster |
| resources | object | `{}` | CPU/Memory resource requests/limits |
| scheduledBackups | object | `{}` | ScheduledBackup resources to create for this Cluster resource See: https://cloudnative-pg.io/documentation/1.17/api_reference/#ScheduledBackupSpec |
| tolerations | list | `[]` | Postgres instances labels for tolerations pod assignment |

## License

Copyright (c) 2022 ENIX

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
