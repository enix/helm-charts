# 🫧 ECK Exporter

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![AppVersion: 2.9.2](https://img.shields.io/badge/AppVersion-2.9.2-informational?style=flat-square)
[![Brought by Enix](https://img.shields.io/badge/Brought%20to%20you%20by-ENIX-%23377dff?labelColor=888&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAQAAAC1QeVaAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfkBAkQIg/iouK/AAABZ0lEQVQY0yXBPU8TYQDA8f/zcu1RSDltKliD0BKNECYZmpjgIAOLiYtubn4EJxI/AImzg3E1+AGcYDIMJA7lxQQQQRAiSSFG2l457+655x4Gfz8B45zwipWJ8rPCQ0g3+p9Pj+AlHxHjnLHAbvPW2+GmLoBN+9/+vNlfGeU2Auokd8Y+VeYk/zk6O2fP9fcO8hGpN/TUbxpiUhJiEorTgy+6hUlU5N1flK+9oIJHiKNCkb5wMyOFw3V9o+zN69o0Exg6ePh4/GKr6s0H72Tc67YsdXbZ5gENNjmigaXbMj0tzEWrZNtqigva5NxjhFP6Wfw1N1pjqpFaZQ7FAY6An6zxTzHs0BGqY/NQSnxSBD6WkDRTf3O0wG2Ztl/7jaQEnGNxZMdy2yET/B2xfGlDagQE1OgRRvL93UOHqhLnesPKqJ4NxLLn2unJgVka/HBpbiIARlHFq1n/cWlMZMne1ZfyD5M/Aa4BiyGSwP4Jl3UAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDQtMDlUMTQ6MzQ6MTUrMDI6MDDBq8/nAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA0LTA5VDE0OjM0OjE1KzAyOjAwsPZ3WwAAAABJRU5ErkJggg==)](https://enix.io)

A Prometheus exporter for [Elastic Cloud on Kubernetes (ECK)](https://github.com/elastic/cloud-on-k8s), put together with [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics) and a custom configuration.  
It exposes metrics on the operator's Custom Resources and their current statuses and reconciliation progress. A configurable set of Prometheus alerts is provided for convenience.

Supported CRDs:
* Elasticsearch
* Kibana
* ApmServer
* Agent

The following metrics are available:
* `eck_elasticsearch_info` (version, desired_version)
* `eck_elasticsearch_health` (red, yellow, green, unknown)
* `eck_elasticsearch_phase` (Ready, ApplyingChanges, MigratingData, Stalled, Invalid)
* `eck_elasticsearch_condition` (ReconciliationComplete, RunningDesiredVersion, ElasticsearchIsReachable, ResourcesAwareManagement)
* `eck_kibana_info` (version, desired_version)
* `eck_kibana_health` (red, yellow, green, unknown)
* `eck_apmserver_info` (version, desired_version)
* `eck_apmserver_health` (red, yellow, green, unknown)
* `eck_agent_info` (version, desired_version)
* `eck_agent_health` (red, yellow, green, unknown)

Shipped with Prometheus alerts:
* `EckElasticsearchHealth`
* `EckElasticsearchPhase`
* `EckElasticsearchUnreachable`
* `EckElasticsearchReconciliationTooLong`
* `EckElasticsearchUpgradeTooLong`
* `EckElasticsearchApplyingChangesTooLong`
* `EckElasticsearchMigratingDataTooLong`
* `EckKibanaHealth`
* `EckApmServerHealth`
* `EckAgentHealth`

[Chart values](#⚙️-values) offer knobs to disable or customize default alerts, and even inject your own.

## 🏃 Installation

It only takes two commands to install if you're running prometheus-operator (kube-prometheus-stack).

Add our Charts repository:
```console
$ helm repo add enix https://charts.enix.io
```
Install eck-exporter:
```console
$ helm install eck-exporter enix/eck-exporter
```

If installation failed or you can't get new metrics in Prometheus, please review [Chart values](#⚙️-values).  
With clusters that don't use the Prometheus operator at all — missing the CRDs — disable resource creation and perhaps add Pod
annotations for scrapping with classic Kubernetes service discovery:
```yaml
podAnnotations:
  prometheus.io/port: "9793"
  prometheus.io/scrape: "true"
service:
  create: false
serviceMonitor:
  create: false
prometheusRules:
  create: false
```

## ❓ FAQ

> Why not simply use [elasticsearch_exporter](https://github.com/prometheus-community/elasticsearch_exporter)?

Yes you should! This project is in no way a substitute for the Elasticsearch exporter which provides vast amounts of metrics.

Our only goal was to bridge the gap of not having visibility on ECK reconciliation loops. It also brings a little observability of other applications managed by the operator. Some it's difficult to get statuses for in a Prometheus centric supervision.

With that being said, if not having elasticsearch_exporter installed at all, this ECK exporter will still bring you basic health informations for bare minimum alerting. With little effort as there is no need to configure authentication. Then when an alert is raised, further investigations can be conducted using native Elastic APIs and metrics.

> Could you add a metric for XYZ, please?

Before submitting a request for a new metric, please be aware of the very limited scope of eck-exporter.  
Firstly there are limitations with the use of kube-state-metrics, which has a declarative model to create metrics and does not permit any processing. This means we basically can only extract data as presented in ECK resources already. And no direct communication is made with the running operator.  
Going back to the goal for this project, we also don't want to become too redundant with elasticsearch_exporter and Kubernetes Pod metrics.

> Why make a dedicated chart? I already run [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics) and could use your `--custom-resource-state-config-file`.

We wanted to provide the same experience as installing a full-fledged and well packaged exporter, with all prometheus-operator facilities ready in seconds. It's also better for continuous improvement and testing, as it's a convenient platform to receive contributions on.  
Should this project evolve to a dedicated codebase — whatever the reason would be — we'll be able to offer a clear and smooth transition to existing users.

> How do you manage GVK version bumps in ECK's CRDs?

Great question... To be answered when the need arises 😅

## ⚙️ Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| eckResources.elasticsearches | bool | `true` | Whether to produce metrics for ECK's Elasticsearch objects or not |
| eckResources.kibanas | bool | `true` | Whether to produce metrics for ECK's Kibana objects or not |
| eckResources.apmservers | bool | `true` | Whether to produce metrics for ECK's ApmServer objects or not |
| eckResources.agents | bool | `true` | Whether to produce metrics for ECK's Agent objects or not |
| prometheusRules.create | bool | `true` | Should a PrometheusRule object be installed to alert on certificate expiration. For prometheus-operator (kube-prometheus) users. |
| prometheusRules.extraLabels | object | `{}` | Additional labels to add to PrometheusRule objects |
| prometheusRules.alertExtraLabels | object | `{}` | Additional labels to add to PrometheusRule rules |
| prometheusRules.alertExtraAnnotations | object | `{}` | Additional annotations to add to PrometheusRule rules |
| prometheusRules.rulePrefix | string | `""` | Additional rulePrefix to PrometheusRule rules |
| prometheusRules.disableBuiltinAlertGroup | bool | `false` | Skip all built-in alerts when using extraAlertGroups |
| prometheusRules.extraAlertGroups | list | `[]` | Additional alert groups for custom configuration (example in `values.yaml`) |
| prometheusRules.builtinAlerts.EckElasticsearchHealth.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckElasticsearchHealth.for | string | `"1m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchHealth.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchHealth.averageThresholdOver | float | `0.2` |  |
| prometheusRules.builtinAlerts.EckElasticsearchHealth.severity.yellow | string | `"warning"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchHealth.severity.red | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchHealth.severity.unknown | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.for | string | `"1m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.averageThresholdUnder | float | `0.8` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.averageThresholdOver | float | `0.2` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.severity.NotReady | string | `"warning"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.severity.ApplyingChanges | string | `"warning"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.severity.MigratingData | string | `"warning"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.severity.Stalled | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchPhase.severity.Invalid | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUnreachable.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUnreachable.for | string | `"1m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUnreachable.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUnreachable.averageThresholdUnder | float | `0.5` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUnreachable.severity | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchReconciliationTooLong.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckElasticsearchReconciliationTooLong.for | string | `"1h"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchReconciliationTooLong.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchReconciliationTooLong.averageThresholdUnder | float | `0.8` |  |
| prometheusRules.builtinAlerts.EckElasticsearchReconciliationTooLong.severity | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUpgradeTooLong.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUpgradeTooLong.for | string | `"1h"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUpgradeTooLong.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUpgradeTooLong.averageThresholdUnder | float | `0.8` |  |
| prometheusRules.builtinAlerts.EckElasticsearchUpgradeTooLong.severity | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchApplyingChangesTooLong.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckElasticsearchApplyingChangesTooLong.for | string | `"1h"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchApplyingChangesTooLong.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchApplyingChangesTooLong.averageThresholdOver | float | `0.2` |  |
| prometheusRules.builtinAlerts.EckElasticsearchApplyingChangesTooLong.severity | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchMigratingDataTooLong.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckElasticsearchMigratingDataTooLong.for | string | `"1h"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchMigratingDataTooLong.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckElasticsearchMigratingDataTooLong.averageThresholdOver | float | `0.2` |  |
| prometheusRules.builtinAlerts.EckElasticsearchMigratingDataTooLong.severity | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckKibanaHealth.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckKibanaHealth.for | string | `"1m"` |  |
| prometheusRules.builtinAlerts.EckKibanaHealth.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckKibanaHealth.averageThresholdOver | float | `0.2` |  |
| prometheusRules.builtinAlerts.EckKibanaHealth.severity.yellow | string | `"warning"` |  |
| prometheusRules.builtinAlerts.EckKibanaHealth.severity.red | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckKibanaHealth.severity.unknown | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckApmServerHealth.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckApmServerHealth.for | string | `"1m"` |  |
| prometheusRules.builtinAlerts.EckApmServerHealth.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckApmServerHealth.averageThresholdOver | float | `0.2` |  |
| prometheusRules.builtinAlerts.EckApmServerHealth.severity.yellow | string | `"warning"` |  |
| prometheusRules.builtinAlerts.EckApmServerHealth.severity.red | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckApmServerHealth.severity.unknown | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckAgentHealth.create | bool | `true` |  |
| prometheusRules.builtinAlerts.EckAgentHealth.for | string | `"1m"` |  |
| prometheusRules.builtinAlerts.EckAgentHealth.averageInterval | string | `"5m"` |  |
| prometheusRules.builtinAlerts.EckAgentHealth.averageThresholdOver | float | `0.2` |  |
| prometheusRules.builtinAlerts.EckAgentHealth.severity.yellow | string | `"warning"` |  |
| prometheusRules.builtinAlerts.EckAgentHealth.severity.red | string | `"critical"` |  |
| prometheusRules.builtinAlerts.EckAgentHealth.severity.unknown | string | `"critical"` |  |
| serviceMonitor.create | bool | `true` | Should a ServiceMonitor object be installed to scrape this exporter. For prometheus-operator (kube-prometheus-stack) users. |
| serviceMonitor.namespace | string | `""` | Optional namespace in which to create the ServiceMonitor. Could be where prometheus-operator is running. |
| serviceMonitor.jobLabel | string | `""` | Optional name of the label on the target Service to use as the job name in Prometheus |
| serviceMonitor.interval | string | `"30s"` | Endpoint scrape interval set in the ServiceMonitor. Warning: increasing this will require changes in built-in alerts settings for averaging! Make sure you understand how `avg_over_time` is used. |
| serviceMonitor.scrapeTimeout | string | `"20s"` | Endpoint scrape timeout set in the ServiceMonitor |
| serviceMonitor.honorLabels | bool | `false` | Whether to honor metrics labels or not |
| serviceMonitor.extraLabels | object | `{}` | Additional labels to add to ServiceMonitor objects |
| serviceMonitor.relabelings | list | `[]` | Relabel config for the ServiceMonitor |
| serviceMonitor.metricRelabelings | list | `[]` | Metric relabel config for the ServiceMonitor |
| serviceMonitor.extraParameters | object | `{}` | Any extra parameter to be added to the endpoint configured in the ServiceMonitor |
| imagePullSecrets | list | `[]` | Specify docker-registry secret names as an array |
| image.registry | string | `"registry.k8s.io"` | kube-state-metrics image registry |
| image.repository | string | `"kube-state-metrics/kube-state-metrics"` | kube-state-metrics image repository |
| image.tag | string | `""` | kube-state-metrics image tag (defaults to Chart appVersion) |
| image.tagSuffix | string | `""` | Suffix added to kube-state-metrics image tag |
| image.pullPolicy | string | `"IfNotPresent"` | kube-state-metrics image pull policy |
| resources | object | check `values.yaml` | ResourceRequirements for the kube-state-metrics container |
| extraLabels | object | `{}` | Additional labels added to all chart objects |
| podExtraLabels | object | `{}` | Additional labels added to all Pods |
| podAnnotations | object | `{}` | Annotations added to all Pods |
| podListenPort | int | `8080` | TCP port to expose the Pod on |
| service.create | bool | `true` | Should a Service be installed (required for ServiceMonitor) |
| service.type | string | `"ClusterIP"` | Type of the Service to be created |
| service.clusterIP | string | `""` | Optional: set IP address for a Service of type ClusterIP. Use `None` to make it a headless Service. |
| service.port | int | `8080` | TCP port to expose the Service on |
| service.extraLabels | object | `{}` | Additional labels to add to the Service |
| service.annotations | object | `{}` | Annotations to add to the Service |
| rbac.create | bool | `true` | Whether to create and use RBAC resources or not |
| serviceAccount.create | bool | `true` | Whether a ServiceAccount should be created or not |
| serviceAccount.annotations | object | `{}` | Annotations added to the ServiceAccount if created |
| serviceAccount.name | string | `""` | Name of the ServiceAccount for the ServiceAccount (required if `rbac.create=false`) |
| serviceAccount.automountServiceAccountToken | bool | `true` | Whether to automount the ServiceAccount token or not |
| podSecurityContext | object | `{}` | SecurityContext for the kube-state-metrics Pod |
| securityContext | object | check `values.yaml` | SecurityContext for the kube-state-metrics container |
| priorityClassName | string | `""` | PriorityClassName for the kube-state-metrics Pod |
| nodeSelector | object | `{}` | Node selector for the kube-state-metrics Pod |
| tolerations | list | `[]` | Tolerations for the kube-state-metrics Pod |
| affinity | object | `{}` | Affinity for the kube-state-metrics Pod |
| extraDeploy | list | `[]` | Additional objects to deploy with the release |
| extraDeployVerbatim | list | `[]` | Same as `extraDeploy` but objects won't go through the templating engine |
| nameOverride | string | `""` | Partially override eck-exporter.fullname template (will prepend the release name) |
| fullnameOverride | string | `""` | Fully override eck-exporter.fullname template |
| kubeVersion | string | `""` | Override Kubernetes version detection ; usefull with "helm template" |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

## ⚖️ License

```
Copyright (c) 2023 ENIX

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
