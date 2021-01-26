# dothill-provisioner

![Version: 2.3.2](https://img.shields.io/badge/Version-2.3.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.3.2](https://img.shields.io/badge/AppVersion-v2.3.2-informational?style=flat-square)

Dothill (Seagate) AssuredSAN dynamic provisioner for Kubernetes (CSI plugin).

## 📜 Using the Chart

### Installing the Chart

Create a file named `dothill-provisioner.values.yaml` with your values, with the help of [Chart Values](#values).

Add our Charts repository:
```
$ helm repo add enix https://charts.enix.io
```

Install the dothill-provisioner with release name `dothill-provisioner` in the `dothill-system` namespace:
```
$ helm install -n dothill-system dothill-provisioner enix/dothill-provisioner --values dothill-provisioner.values.yaml
```

The `upgrade` command is used to change configuration when values are modified:
```
$ helm upgrade -n dothill-system dothill-provisioner enix/dothill-provisioner --values dothill-provisioner.values.yaml
```

### Upgrading the Chart

Update Helm repositories:
```
$ helm repo update
```

Upgrade release names `dothill-provisioner` to the latest version:
```
$ helm upgrade dothill-provisioner enix/dothill-provisioner
```

### Creating a storage class

In order to dynamically provision persistants volumes, you first need to create a storage class:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
provisioner: dothill.csi.enix.io # Required for the plugin to recognize this storage class as handled by itself.
volumeBindingMode: WaitForFirstConsumer # Prefer this value to avoid unschedulable pods (https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode)
metadata:
  name: my-marvelous-storage # Choose the name that fits the best with your StorageClass.
parameters:
  # Secrets name and namespace, they can be the same for provisioner and controller-publish section.
  csi.storage.k8s.io/provisioner-secret-name: dothill-api
  csi.storage.k8s.io/provisioner-secret-namespace: dothill-system
  csi.storage.k8s.io/controller-publish-secret-name: dothill-api
  csi.storage.k8s.io/controller-publish-secret-namespace: dothill-system
  fsType: ext4 # Desired filesystem
  iqn: iqn.2015-11.com.hpe:storage.msa2050.2002518b4c # Appliance IQN
  pool: A # Pool to use on the IQN to provision volumes
  portals: 10.0.0.24,10.0.0.25 # Comma separated list of portal ips. (One per controller should be enough).
```

And the associated secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: dothill-api
  namespace: dothill-system
type: Opaque
data:
  apiAddress: aHR0cHM6Ly8xMC4wLjAuNDI= # base64 encoded api address
  username: am9obi5kb2U= # base64 encoded username
  password: bXktU0BmZStwYXNzdzByZCE= # base64 encoded password
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Paul Laffitte | paul.laffitte@enix.fr | https://blog.paullaffitte.com |
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
| image.repository | string | `"docker.io/enix/dothill-provisioner"` | Docker repository to use for nodes and controller |
| image.tag | string | The chart will use the appVersion value by default if not given. | Tag to use for nodes and controller |
| kubeletPath | string | `"/var/lib/kubelet"` | Path to kubelet |
| multipathd.extraArgs | list | `[]` | Extra arguments for multipathd containers |
| node.extraArgs | list | `[]` | Extra arguments for dothill-node containers |
| nodeLivenessProbe | object | `{"extraArgs":[],"image":{"repository":"quay.io/k8scsi/livenessprobe","tag":"v2.2.0"}}` | Container that convert CSI liveness probe to kubernetes liveness/readiness probe |
| nodeLivenessProbe.extraArgs | list | `[]` | Extra arguments for the node's liveness probe containers |
| nodeServer.nodeAffinity | string | `nil` | Kubernetes nodeAffinity field for dothill-node-server Pod |
| nodeServer.nodeSelector | string | `nil` | Kubernetes nodeSelector field for dothill-node-server Pod |
| pspAdmissionControllerEnabled | bool | `false` | Wether psp admission controller has been enabled in the cluster or not |
