# dothill-csi

A dynamic persistent volume (PV) provisioner for Dothill AssuredSAN based storage systems.

![Version: 3.1.2](https://img.shields.io/badge/Version-3.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v3.1.2](https://img.shields.io/badge/AppVersion-v3.1.2-informational?style=flat-square)
[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/enix)](https://artifacthub.io/packages/search?repo=enix)

# Introduction
As of version `3.0.0`, this `csi` driver and its helm chart are released as open-source projects under the MIT license.

Your contribution is obviously most welcomed !

**Homepage:** <https://github.com/enix/dothill-csi>

## This helm chart
Is part of the project and is published on [Enix](https://enix.io)'s charts repository.

## Source Code

* <https://github.com/enix/dothill-csi/tree/main/helm/dothill-csi>

# Installing the Chart

Create a file named `dothill-csi.values.yaml` with your values, with the help of [Chart Values](#values).

Add our Charts repository:
```
$ helm repo add enix https://charts.enix.io
```

Install the dothill-csi with release name `dothill-csi` in the `dothill-system` namespace:
```
$ helm install -n dothill-system dothill-csi enix/dothill-csi --values dothill-csi.values.yaml
```

The `upgrade` command is used to change configuration when values are modified:
```
$ helm upgrade -n dothill-system dothill-csi enix/dothill-csi --values dothill-csi.values.yaml
```

# Upgrading the Chart

Update Helm repositories:
```
$ helm repo update
```

Upgrade release names `dothill-csi` to the latest version:
```
$ helm upgrade dothill-csi enix/dothill-csi
```

# Creating a storage class

In order to dynamically provision persistants volumes, you first need to create a storage class. To do so, please refer to the project [documentation](https://github.com/enix/dothill-csi).

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Enix | contact@enix.fr | https://github.com/enixsas |
| Paul Laffitte | paul.laffitte@enix.fr | https://blog.plaffitt.com |
| Alexandre Buisine | alexandre.buisine@enix.fr |  |
| Arthur Chaloin | arthur.chaloin@enix.fr |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controller.extraArgs | list | `[]` | Extra arguments for dothill-controller container |
| csiAttacher | object | `{"extraArgs":[],"image":{"repository":"k8s.gcr.io/sig-storage/csi-attacher","tag":"v2.2.1"},"timeout":"30s"}` | Controller sidecar for attachment handling |
| csiAttacher.extraArgs | list | `[]` | Extra arguments for csi-attacher controller sidecar |
| csiAttacher.timeout | string | `"30s"` | Timeout for gRPC calls from the csi-attacher to the controller |
| csiNodeRegistrar | object | `{"extraArgs":[],"image":{"repository":"k8s.gcr.io/sig-storage/csi-node-driver-registrar","tag":"v2.1.0"}}` | Node sidecar for plugin registration |
| csiNodeRegistrar.extraArgs | list | `[]` | Extra arguments for csi-node-registrar node sidecar |
| csiProvisioner | object | `{"extraArgs":[],"image":{"repository":"k8s.gcr.io/sig-storage/csi-provisioner","tag":"v2.1.0"},"timeout":"30s"}` | Controller sidecar for provisionning |
| csiProvisioner.extraArgs | list | `[]` | Extra arguments for csi-provisioner controller sidecar |
| csiProvisioner.timeout | string | `"30s"` | Timeout for gRPC calls from the csi-provisioner to the controller |
| csiResizer | object | `{"extraArgs":[],"image":{"repository":"k8s.gcr.io/sig-storage/csi-resizer","tag":"v1.1.0"}}` | Controller sidecar for volume expansion |
| csiResizer.extraArgs | list | `[]` | Extra arguments for csi-resizer controller sidecar |
| csiSnapshotter | object | `{"extraArgs":[],"image":{"repository":"k8s.gcr.io/sig-storage/csi-snapshotter","tag":"v4.0.0"}}` | Controller sidecar for snapshots handling |
| csiSnapshotter.extraArgs | list | `[]` | Extra arguments for csi-snapshotter controller sidecar |
| image.repository | string | `"docker.io/enix/dothill-csi"` | Docker repository to use for nodes and controller |
| image.tag | string | The chart will use the appVersion value by default if not given. | Tag to use for nodes and controller |
| kubeletPath | string | `"/var/lib/kubelet"` | Path to kubelet |
| multipathd.extraArgs | list | `[]` | Extra arguments for multipathd containers |
| node.extraArgs | list | `[]` | Extra arguments for dothill-node containers |
| nodeLivenessProbe | object | `{"extraArgs":[],"image":{"repository":"quay.io/k8scsi/livenessprobe","tag":"v2.2.0"}}` | Container that convert CSI liveness probe to kubernetes liveness/readiness probe |
| nodeLivenessProbe.extraArgs | list | `[]` | Extra arguments for the node's liveness probe containers |
| nodeServer.nodeAffinity | string | `nil` | Kubernetes nodeAffinity field for dothill-node-server Pod |
| nodeServer.nodeSelector | string | `nil` | Kubernetes nodeSelector field for dothill-node-server Pod |
| podMonitor.enabled | bool | `false` | Set a Prometheus operator PodMonitor ressource (true or false) |
| pspAdmissionControllerEnabled | bool | `false` | Wether psp admission controller has been enabled in the cluster or not |
| serviceMonitor.enabled | bool | `false` | Set a Prometheus operator ServiceMonitor ressource (true or false) |
