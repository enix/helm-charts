# x509-exporter

<p align="center">
    <a href="https://opensource.org/licenses/Apache-2.0" alt="Apache 2.0 License">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a href="https://enix.io/fr/blog/" alt="Brought to you by ENIX">
        <img src="https://img.shields.io/badge/Brought%20to%20you%20by-ENIX-%23377dff?labelColor=888&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAQAAAC1QeVaAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfkBAkQIg/iouK/AAABZ0lEQVQY0yXBPU8TYQDA8f/zcu1RSDltKliD0BKNECYZmpjgIAOLiYtubn4EJxI/AImzg3E1+AGcYDIMJA7lxQQQQRAiSSFG2l457+655x4Gfz8B45zwipWJ8rPCQ0g3+p9Pj+AlHxHjnLHAbvPW2+GmLoBN+9/+vNlfGeU2Auokd8Y+VeYk/zk6O2fP9fcO8hGpN/TUbxpiUhJiEorTgy+6hUlU5N1flK+9oIJHiKNCkb5wMyOFw3V9o+zN69o0Exg6ePh4/GKr6s0H72Tc67YsdXbZ5gENNjmigaXbMj0tzEWrZNtqigva5NxjhFP6Wfw1N1pjqpFaZQ7FAY6An6zxTzHs0BGqY/NQSnxSBD6WkDRTf3O0wG2Ztl/7jaQEnGNxZMdy2yET/B2xfGlDagQE1OgRRvL93UOHqhLnesPKqJ4NxLLn2unJgVka/HBpbiIARlHFq1n/cWlMZMne1ZfyD5M/Aa4BiyGSwP4Jl3UAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDQtMDlUMTQ6MzQ6MTUrMDI6MDDBq8/nAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA0LTA5VDE0OjM0OjE1KzAyOjAwsPZ3WwAAAABJRU5ErkJggg==" /></a>
</p>

Prometheus exporter for X.509 certificates enabling expiration monitoring

Currently, it will only target files and directories on cluster nodes using `hostPath`.

**Homepage:** <https://github.com/enix/x509-exporter>

## TL;DR;

For a typical kubeadm deployed cluster with prometheus-operator :

```
$ cat values.yaml
exporter:
  watchFiles:
    - /var/lib/kubelet/pki/kubelet-client-current.pem
    - /var/lib/kubelet/pki/kubelet.crt
  watchDirectories:
  watchDirectories:
    - /etc/kubernetes/pki/
    - /etc/kubernetes/pki/etcd/
  watchKubeconfFiles:
    - /etc/kubernetes/kubelet.conf
    - /etc/kubernetes/admin.conf
prometheusServiceMonitor:
  create: true
prometheusRules:
  create: true
tolerations:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
    operator: Exists

$ helm repo add enix https://charts.enix.io
$ helm install my-release enix/x509-exporter -f values.yaml
```

## Installing the Chart

You'll have to define values as the exporter won't provide any metric when
using defaults.
A good starting point is to identify paths for cluster certificates in your
Kubernetes distribution. Expiration of cluster certificates can cause
significant outages so you'd want to alerted if renewal is required.

On a kubeadm deployed cluster, we'd want to watch kubelet certificates as
well as the PKI directory. If your Kubeconfig files also contain embedded
certificates, it can be passed to the exporter too. Adapt the following to your
Kubernetes deployment :
```yaml
exporter:
  watchFiles:
    - /var/lib/kubelet/pki/kubelet-client-current.pem
    - /var/lib/kubelet/pki/kubelet.crt
  watchDirectories:
    - /etc/kubernetes/pki/
    - /etc/kubernetes/pki/etcd/
  watchKubeconfFiles:
    - /etc/kubernetes/kubelet.conf
    - /etc/kubernetes/admin.conf
```

**Note :** because all nodes may not hold the same sets of certificate
files, it is recommended to install as many releases of this chart as
you have node kinds. That way each one gets a targetted configuration,
the exporter won't try openning missing files or kubernetes mount
empty directories.

When watching cluster certificates, you would also want the x509-exporter
DaemonSet to be running on master nodes and other control-plane nodes.
Tolerations have to be set for the NoSchedule effect. Again, on a kubeadm
cluster you could use :
```yaml
tolerations:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
    operator: Exists
```
Other distributions such as Rancher Kubernetes Engine (RKE) may require
additionnal tolerations for master nodes :
```yaml
tolerations:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
    operator: Exists
  - effect: NoSchedule
    key: node-role.kubernetes.io/controlplane
    operator: Exists
  - effect: NoExecute
    key: node-role.kubernetes.io/etcd
    operator: Exists
```

For prometheus-operator users, this Chart can install a `ServiceMonitor` and
a `PrometheusRules` ressources to have the x509-exporter service auto-discovered
and Alertmanager notify on certificate expiry. Check the
[Chart Values](#chart-values) for options.

To install the chart with the release name `my-release`:

```
$ helm install my-release enix/x509-exporter -f values.yaml
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | affinity configuration on Pods |
| exporter.watchDirectories | list | `[]` | Directories to scan for certificates to be watched and exported |
| exporter.watchFiles | list | `[]` | Certificate files to watch and export metrics about (PEM encoded X.509) |
| exporter.watchKubeconfFiles | list | `[]` | Kubeconf files scanned for embedded certificates to export metrics about |
| extraLabels | object | `{}` | Extra labels to add on chart resources |
| fullnameOverride | string | `""` | String to fully override x509-exporter.fullname template with a string |
| image.pullPolicy | string | `"IfNotPresent"` | x509-exporter image pull policy |
| image.repository | string | `"enix/x509-exporter"` | x509-exporter image repository |
| image.tag | string | `nil` | x509-exporter image version |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` | String to partially override x509-exporter.fullname template with a string (will prepend the release name) |
| nodeSelector | object | `{}` | nodeSelector configuration on Pods |
| podAnnotations | object | `{}` | annotations to add on Pods |
| podExtraLabels | object | `{}` | extra labels to add on Pods |
| podListenPort | int | `9090` | TCP port to expose Pods on (whether kube-rbac-proxy is enabled or not) |
| podSecurityContext | object | `{}` | securityContext configuration on Pods |
| prometheusRules.create | bool | `false` | Install a PrometheusRule ressource to alert on certificate expiration (for prometheus-operator users) |
| prometheusRules.criticalDaysLeft | int | `30` | Raise a critical alert when this little days are left before a certificate expiration |
| prometheusRules.extraLabels | object | `{}` | Extra labels to add on PrometheusRule ressources |
| prometheusRules.warningDaysLeft | int | `90` | Raise a warning alert when this little days are left before a certificate expiration |
| prometheusServiceMonitor.create | bool | `false` | Install a ServiceMonitor ressource to scrape this exporter (for prometheus-operator users) |
| prometheusServiceMonitor.extraLabels | object | `{}` | Extra labels to add on ServiceMonitor ressources |
| prometheusServiceMonitor.relabelings | object | `{}` | Relabel config for the ServiceMonitor, see: https://coreos.com/operators/prometheus/docs/latest/api.html#relabelconfig |
| prometheusServiceMonitor.scrapeInterval | string | `"60s"` | Target scrape interval to be set in the ServiceMonitor |
| rbac.create | bool | `true` | specifies whether RBAC resources should be created |
| rbacProxy.enable | bool | `false` | Use kube-rbac-proxy to expose exporters |
| rbacProxy.imagePullPolicy | string | `"IfNotPresent"` | kube-rbac-proxy image pull policy |
| rbacProxy.imageRepository | string | `"quay.io/coreos/kube-rbac-proxy"` | kube-rbac-proxy image repository |
| rbacProxy.imageTag | string | `"v0.4.1"` | kube-rbac-proxy image version |
| rbacProxy.upstreamListenPort | int | `9091` | Listen port for the exporter inside kube-rbac-proxy exposed Pods |
| resources | object | `{}` | resources configuration on Pods |
| restartPolicy | string | `"Always"` | Pods restart policy |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | securityContext configuration on x509-exporter containers |
| service.annotations | object | `{}` | annotations to add to the service |
| service.create | bool | `true` | Install a headless service (required for ServiceMonitor) |
| service.extraLabels | object | `{}` | extra labels to add to the service |
| service.port | int | `9090` | TCP port to expose the service on |
| serviceAccount.annotations | object | `{}` | annotations added to the ServiceAccount |
| serviceAccount.create | bool | `true` | specifies whether a ServiceAccount should be created |
| serviceAccount.name | string | `nil` | name of the ServiceAccount to use (defaults to a name generated using the fullname template) |
| tolerations | list | `[]` | tolerations configuration on Pods |
| updateStrategy | object | `{}` | updateStrategy configuration on Pods |

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
