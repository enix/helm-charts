# 🔏 X.509 Exporter

<p align="center">
    <a href="https://opensource.org/licenses/Apache-2.0" alt="Apache 2.0 License">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a href="https://enix.io/fr/blog/" alt="Brought to you by ENIX">
        <img src="https://img.shields.io/badge/Brought%20to%20you%20by-ENIX-%23377dff?labelColor=888&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAQAAAC1QeVaAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfkBAkQIg/iouK/AAABZ0lEQVQY0yXBPU8TYQDA8f/zcu1RSDltKliD0BKNECYZmpjgIAOLiYtubn4EJxI/AImzg3E1+AGcYDIMJA7lxQQQQRAiSSFG2l457+655x4Gfz8B45zwipWJ8rPCQ0g3+p9Pj+AlHxHjnLHAbvPW2+GmLoBN+9/+vNlfGeU2Auokd8Y+VeYk/zk6O2fP9fcO8hGpN/TUbxpiUhJiEorTgy+6hUlU5N1flK+9oIJHiKNCkb5wMyOFw3V9o+zN69o0Exg6ePh4/GKr6s0H72Tc67YsdXbZ5gENNjmigaXbMj0tzEWrZNtqigva5NxjhFP6Wfw1N1pjqpFaZQ7FAY6An6zxTzHs0BGqY/NQSnxSBD6WkDRTf3O0wG2Ztl/7jaQEnGNxZMdy2yET/B2xfGlDagQE1OgRRvL93UOHqhLnesPKqJ4NxLLn2unJgVka/HBpbiIARlHFq1n/cWlMZMne1ZfyD5M/Aa4BiyGSwP4Jl3UAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDQtMDlUMTQ6MzQ6MTUrMDI6MDDBq8/nAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA0LTA5VDE0OjM0OjE1KzAyOjAwsPZ3WwAAAABJRU5ErkJggg==" /></a>
</p>

A Prometheus exporter for certificates focusing on expiration monitoring, written in Go with cloud deployments in mind.

Get notified before they expire:
* PEM encoded files, by path or scanning directories
* Kubeconfigs with embedded certificates or file references
* TLS Secrets from a Kubernetes cluster

The following metrics are available:
* `x509_cert_not_before`
* `x509_cert_not_after`
* `x509_cert_expired`
* `x509_read_errors`

## 🏃 TL;DR

It only takes two commands to install x509-exporter, however you should read instructions in the next section to take
advantage of all the features!

Add our Charts repository :
```
$ helm repo add enix https://charts.enix.io
```
Install x509-exporter for TLS Secrets monitoring with prometheus-operator support :
```
$ helm install x509-exporter enix/x509-exporter
```

To remove built-in Prometheus alerts if you'd rather craft your own :
```
$ helm upgrade x509-exporter enix/x509-exporter --reuse-values --set prometheusRules.create=false
```

If you don't use the Prometheus operator at all, and don't have the CRD, disable resource creation and perhaps add Pod
annotations for scrapping :
```
secretsExporter:
  podAnnotations:
    prometheus.io/port: "9090"
    prometheus.io/scrape: "true"
service:
  create: false
prometheusServiceMonitor:
  create: false
prometheusRules:
  create: false
```

## 📜 Using the Chart

This will guide you through writing the initial set of values.

### Metrics for TLS Secrets

By default we only run a Deployment to provide metrics on TLS Secrets stored in the Kubernetes cluster. It helps
detect expiring certificates whether you manage them on your own or rely on controllers such as
[cert-manager](https://cert-manager.io).
> 🙂 If you're only interested in this feature, you could probably install the Chart not specifying any value.

Disable this exporter when Secrets metrics are not wanted – if you're looking for hostPath DaemonSets only :
```
secretsExporter:
  enabled: false
```

### Metrics for node certificates (hostPath)

Kubernetes components use many certificates to authenticate and secure communications between each others. This PKI is
critical to the operation of a cluster and it's health should be monitored carefully. Expiring Kubernetes certificates
is a common source of outage, and depending on your distribution could happen a few months after installation if left
unattended.

This Chart provide a facility to deploy `DaemonSets` so that each node of a cluster can run it's own x509-exporter
and export metrics for host files :
* `etcd` server and client certificates
* Kubernetes CA
* `kube-apiserver` certificates
* `kubelet` certificates
* kubeconfig files with embedded certificates
* etc.
Obviously it also works with any other application deployed on cluster nodes as long as it's using PEM encoded
certicates (deployment agents, security tools, etc.).

> ⚙️ You'll have to compile a list of files and directories of interest. There is no "one size fits all" configuration
that we could recommend, or even a decent boilerplate. Examples bellow should give an idea of what to look after.

> 🏙️ While having a single DaemonSet sounds like a fair option, it is not uncommon for nodes to assume different roles,
and as a result hold different sets of certificate files requiring targetted x509-exporter configurations.
For example, with the help of node selectors and tolerations, we can have nodes of the control plane run their own
exporter targetting API and etcd certificates, while regular nodes would have a simpler configuration for Kubelet alone.

Deployment of hostPath exporters is controlled under the `hostPathsExporter` key of [Chart Values](#chart-values).
All values are defaults that would apply to any number of DaemonSet you wish to run, unless overriden individually.
Then you'll need to create at least one DaemonSet in `hostPathsExporter.daemonSets`.

This is the most basic configuration. It will create one DaemonSet named `nodes` with an empty configuration. Exporters
won't export no certificate metric.
```
hostPathsExporter:
  daemonSets:
    nodes: {}
```

Moving on, we can add all flavors of "watch" settings :
* `watchDirectories` : to monitor all PEM files found in a host directory (no recursion in sub directories)
* `watchFiles` : to target known file paths, this is highly recommended over the directory option when file paths are
predictible
* `watchKubeconfFiles` : look for base64 encoded embedded certificates in Kubeconfig files

This will create a DaemonSet able to monitor the same files on all nodes. It could fit a typical kubeadm cluster with no
control plane dedicated nodes :
```
hostPathsExporter:
  daemonSets:
    nodes:
      watchDirectories:
      - /etc/kubernetes/pki/
      - /etc/kubernetes/pki/etcd/
      watchFiles:
      - /var/lib/kubelet/pki/kubelet-client-current.pem
      - /var/lib/kubelet/pki/kubelet.crt
      watchKubeconfFiles:
      - /etc/kubernetes/kubelet.conf
      - /etc/kubernetes/admin.conf
```

Dedicated nodes will require other DaemonSets. Based on our kubeadm example, it could be extended like this :
```
hostPathsExporter:
  podAnnotations:
    prometheus.io/port: "9090"
    prometheus.io/scrape: "true"

  daemonSets:
    cp:
      nodeSelector:
        node-role.kubernetes.io/master: ""
      tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
        operator: Exists
      watchDirectories:
      - /etc/kubernetes/pki/
      - /etc/kubernetes/pki/etcd/
      watchFiles:
      - /var/lib/kubelet/pki/kubelet-client-current.pem
      - /var/lib/kubelet/pki/kubelet.crt
      watchKubeconfFiles:
      - /etc/kubernetes/kubelet.conf
      - /etc/kubernetes/admin.conf

    nodes:
      tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/ingress
        operator: Exists
      watchDirectories:
      - /etc/kubernetes/pki/
      watchFiles:
      - /var/lib/kubelet/pki/kubelet-client-current.pem
      - /var/lib/kubelet/pki/kubelet.crt
      watchKubeconfFiles:
      - /etc/kubernetes/kubelet.conf
```

With this last configuration we demonstrated :
* using `podAnnotations` under `hostPathsExporter`, as a result it will apply
to all `hostPathsExporter.daemonSets` because they don't override that setting
* two DaemonSets, `cp` for control plane nodes, and `nodes` for regular ones
* `nodeSelector` on the control plane DaemonSet to schedule Pods on "masters"
only
* `tolerations` for both. On `cp` it's required to be scheduled on those tainted
nodes. Because this cluster would also have nodes dedicated to ingress
controllers, DaemonSet `nodes` also gets a toleration for this role.

### Custom Resources for the Prometheus operator

Users of the prometheus-operator will immediately scrape exporters thanks to the creation of a `ServiceMonitor`
resource, and get basic alerting rules from the new `PrometheusRule`.
The operator is usually installed with [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus) or by
the Kubernetes distribution.

When it's missing and you don't have the CRD, helm will raise one of this error :
```
Error: unable to build kubernetes objects from release manifest: [unable to recognize "": no matches for kind "PrometheusRule" in version "monitoring.coreos.com/v1", unable to recognize "": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"]
```
Add the following values to disable the creation of `ServiceMonitors` and `PrometheusRules` :
```
prometheusServiceMonitor:
  create: false
prometheusRules:
  create: false
```
Then perhaps you would need Pod annotations to work with the Kubernetes service discovery in Prometheus :
```
secretsExporter:
  podAnnotations:
    prometheus.io/port: "9090"
    prometheus.io/scrape: "true"
```
Also in such case the headless service may not serve any purpose and can be removed :
```
service:
  create: false
```

> ℹ️ [Chart Values](#chart-values) provide a few knobs to control Prometheus rules, such as numbers of days before
certificate expiration for warning and critical alerts are triggered.

> ⚠️ Special alert `X509ExporterReadErrors` is meant to report anomalies with the exporter, such as API authorization
issues or unreadable files. If the Kubernetes API is unstable it could be disabled with
`prometheusRules.alertOnReadErrors`.\
When using hostPath exporters, and some nodes don't have all the files, it's better to add other DaemonSet profiles
to target each situation and preserve this alert. Detecting configuration regressions is especially important when
working with files that can change path over time and cluster upgrades.

### Installing the Chart

Create a file named `x509-exporter.values.yaml` with your values, as discussed previously and with the help of
[Chart Values](#chart-values).

Add our Charts repository :
```
$ helm repo add enix https://charts.enix.io
```

Install the x509-exporter with release name `x509-exporter` :
```
$ helm install x509-exporter enix/x509-exporter --values x509-exporter.values.yaml
```

The `upgrade` command is used to change configuration when values are modified :
```
$ helm upgrade x509-exporter enix/x509-exporter --values x509-exporter.values.yaml
```

### Upgrading the Chart

Update Helm repositories :
```
$ helm repo update
```

Upgrade release names `x509-exporter` to the latest version :
```
$ helm upgrade x509-exporter enix/x509-exporter
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraLabels | object | `{}` |  |
| fullnameOverride | string | `""` | String to fully override x509-exporter.fullname template with a string |
| hostPathsExporter.affinity | object | `{}` | Affinity for Pods of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.daemonSets | object | `{}` | [SEE README] Map to define one or many DaemonSets running hostPath exporters. Key is used as a name ; value is a map to override all default settings set by `hostPathsExporter.*`. |
| hostPathsExporter.debugMode | bool | `false` | Should debug messages be produced by hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.nodeSelector | object | `{}` | Node selector for Pods of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.podAnnotations | object | `{}` | Annotations added to Pods of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.podExtraLabels | object | `{}` | Extra labels added to Pods of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.podSecurityContext | object | `{}` | PodSecurityContext for Pods of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.resources | object | see values.yaml | ResourceRequirements for containers of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.restartPolicy | string | `"Always"` | restartPolicy for Pods of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.securityContext | object | see values.yaml | SecurityContext for containers of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.tolerations | list | `[]` | Toleration for Pods of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.updateStrategy | object | `{}` | updateStrategy for DaemonSet of hostPath exporters (default for all hostPathsExporter.daemonSets) |
| hostPathsExporter.watchDirectories | list | `[]` | [SEE README] List of directory paths of the host to scan for PEM encoded certificate files to be watched and exported as metrics (one level deep) |
| hostPathsExporter.watchFiles | list | `[]` | [SEE README] List of file paths of the host for PEM encoded certificates to be watched and exported as metrics (one level deep) |
| hostPathsExporter.watchKubeconfFiles | list | `[]` | [SEE README] List of Kubeconf file paths of the host to scan for embedded certificates to export metrics about |
| image.pullPolicy | string | `"IfNotPresent"` | x509-exporter image pull policy |
| image.registry | string | `"docker.io"` | x509-exporter image registry |
| image.repository | string | `"enix/x509-exporter"` | x509-exporter image repository |
| image.tag | string | `nil` | x509-exporter image tag (defaults to Chart appVersion) |
| imagePullSecrets | list | `[]` | Specify docker-registry secret names as an array |
| nameOverride | string | `""` | String to partially override x509-exporter.fullname template with a string (will prepend the release name) |
| podAnnotations | object | `{}` | Annotations added to all Pods |
| podExtraLabels | object | `{}` | Extra labels added to all Pods |
| podListenPort | int | `9090` | TCP port to expose Pods on (whether kube-rbac-proxy is enabled or not) |
| prometheusRules.alertOnReadErrors | bool | `true` | Should the X509ExporterReadErrors alerting rule be created to notify when the exporter can't read files or authenticate with the Kubernetes API. It aims at preventing undetected misconfigurations and monitoring regressions. |
| prometheusRules.create | bool | `true` | Should a PrometheusRule ressource be installed to alert on certificate expiration. For prometheus-operator (kube-prometheus) users. |
| prometheusRules.criticalDaysLeft | int | `14` | Raise a critical alert when this little days are left before a certificate expiration (two weeks to deal with ACME rate limiting should this be an issue) |
| prometheusRules.extraLabels | object | `{}` | Extra labels to add on PrometheusRule ressources |
| prometheusRules.readErrorsSeverity | string | `"warning"` | Severity for the X509ExporterReadErrors alerting rule |
| prometheusRules.warningDaysLeft | int | `28` | Raise a warning alert when this little days are left before a certificate expiration (cert-manager would renew Let's Encrypt certs before day 29) |
| prometheusServiceMonitor.create | bool | `true` | Should a ServiceMonitor ressource be installed to scrape this exporter. For prometheus-operator (kube-prometheus) users. |
| prometheusServiceMonitor.extraLabels | object | `{}` | Extra labels to add on ServiceMonitor ressources |
| prometheusServiceMonitor.relabelings | object | `{}` | Relabel config for the ServiceMonitor, see: https://coreos.com/operators/prometheus/docs/latest/api.html#relabelconfig |
| prometheusServiceMonitor.scrapeInterval | string | `"60s"` | Target scrape interval set in the ServiceMonitor |
| rbac.create | bool | `true` | Should RBAC resources be created |
| rbac.hostPathsExporter.clusterRoleAnnotations | object | `{}` | Annotations added to the ClusterRole for the hostPath exporters |
| rbac.hostPathsExporter.clusterRoleBindingAnnotations | object | `{}` | Annotations added to the ClusterRoleBinding for the hostPath exporters |
| rbac.hostPathsExporter.serviceAccountAnnotations | object | `{}` | Annotations added to the ServiceAccount for the hostPath exporters |
| rbac.hostPathsExporter.serviceAccountName | string | `nil` | Name of the ServiceAccount for hostPath exporters (required if `rbac.create=false`) |
| rbac.secretsExporter.clusterRoleAnnotations | object | `{}` | Annotations added to the ClusterRole for the Secrets exporter |
| rbac.secretsExporter.clusterRoleBindingAnnotations | object | `{}` | Annotations added to the ClusterRoleBinding for the Secrets exporter |
| rbac.secretsExporter.serviceAccountAnnotations | object | `{}` | Annotations added to the ServiceAccount for the Secrets exporter |
| rbac.secretsExporter.serviceAccountName | string | `nil` | Name of the ServiceAccount for the Secrets exporter (required if `rbac.create=false`) |
| rbacProxy.enabled | bool | `false` | Should kube-rbac-proxy be used to expose exporters |
| rbacProxy.image.pullPolicy | string | `"IfNotPresent"` | kube-rbac-proxy image pull policy |
| rbacProxy.image.registry | string | `"quay.io"` | kube-rbac-proxy image registry |
| rbacProxy.image.repository | string | `"coreos/kube-rbac-proxy"` | kube-rbac-proxy image repository |
| rbacProxy.image.tag | string | `"v0.5.0"` | kube-rbac-proxy image version |
| rbacProxy.resources | object | see values.yaml | ResourceRequirements for all containers of kube-rbac-proxy |
| rbacProxy.securityContext | object | see values.yaml | SecurityContext for all containers of kube-rbac-proxy |
| rbacProxy.upstreamListenPort | int | `9091` | Listen port for the exporter running inside kube-rbac-proxy exposed Pods |
| secretsExporter.affinity | object | `{}` | Affinity for Pods of the TLS Secrets exporter |
| secretsExporter.debugMode | bool | `false` | Should debug messages be produced by the TLS Secrets exporter |
| secretsExporter.enabled | bool | `true` | Should the TLS Secrets exporter be running |
| secretsExporter.nodeSelector | object | `{}` | Node selector for Pods of the TLS Secrets exporter |
| secretsExporter.podAnnotations | object | `{}` | Annotations added to Pods of the TLS Secrets exporter |
| secretsExporter.podExtraLabels | object | `{}` | Extra labels added to Pods of the TLS Secrets exporter |
| secretsExporter.podSecurityContext | object | `{}` | PodSecurityContext for Pods of the TLS Secrets exporter |
| secretsExporter.replicas | int | `1` | Desired number of TLS Secrets exporter Pod |
| secretsExporter.resources | object | see values.yaml | ResourceRequirements for containers of the TLS Secrets exporter |
| secretsExporter.restartPolicy | string | `"Always"` | restartPolicy for Pods of the TLS Secrets exporter |
| secretsExporter.securityContext | object | see values.yaml | SecurityContext for containers of the TLS Secrets exporter |
| secretsExporter.strategy | object | `{}` | DeploymentStrategy for the TLS Secrets exporter |
| secretsExporter.tolerations | list | `[]` | Toleration for Pods of the TLS Secrets exporter |
| service.annotations | object | `{}` | Annotations to add to the Service |
| service.create | bool | `true` | Should a headless Service be installed (required for ServiceMonitor) |
| service.extraLabels | object | `{}` | Extra labels to add to the Service |
| service.port | int | `9090` | TCP port to expose the Service on |

## ⚖️ License

Copyright (c) 2020, 2021 ENIX

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
