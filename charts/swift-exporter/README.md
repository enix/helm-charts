# :rotating_light: Swift Exporter

A Prometheus exporter for Swift Object Storage focusing on authentification monitoring, written in Python. Designed to be used within Kubernetes clusters, however it can also be used as a standalone exporter.

![Grafana Dashboard]([./docs/grafana-dashboard.png](https://raw.githubusercontent.com/enix/swift-exporter/master/docs/grafana-dashboard.png))

## 🏃 TL; DR

It only takes two commands to install swift-exporter, however you should read the instructions in the next section to
take advantage of all the features!

Add our Charts repository :
```
$ helm repo add enix https://charts.enix.io
```
Install swift-exporter for TLS Secrets monitoring with prometheus-operator support :
```
$ helm install swift-exporter enix/swift-exporter
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| exporter.request_rate | int | `5` | Defines the exporter's request rate in seconds. |
| exporter.timeout | int | `3` | Exporter's allowed time in seconds to make a request. If this count down reaches 0 a timout exception is raised |
| image.pullPolicy | string | `"IfNotPresent"` | swift-exporter image pull policy |
| image.registry | string | `"docker.io"` | swift-exporter image registry |
| image.repository | string | `"enix/swift-exporter"` | swift-exporter image repository |
| image.tag | string | `nil` | swift-exporter image tag (defaults to Chart appVersion) |
| podAnnotations | object | `{"prometheus.io/port":"8000","prometheus.io/scrape":"true"}` | Annotations added to all Pods |
| podExtraLabels | object | `{}` |  |
| podListenPort | int | `8000` | TCP port to expose Pods on |
| prometheusPodMonitor.create | bool | `false` | Should a PodMonitor ressource be installed to scrape this exporter. For prometheus-operator (kube-prometheus) users. |
| prometheusPodMonitor.extraLabels | object | `{}` | Extra labels to add on PodMonitor ressources |
| prometheusPodMonitor.relabelings | object | `{}` | Relabel config for the PodMonitor, see: https://coreos.com/operators/prometheus/docs/latest/api.html#relabelconfig |
| prometheusPodMonitor.scrapeInterval | string | `"15s"` | Target scrape interval set in the PodMonitor |
| prometheusServiceMonitor.create | bool | `true` | Should a ServiceMonitor ressource be installed to scrape this exporter. For prometheus-operator (kube-prometheus) users. |
| prometheusServiceMonitor.extraLabels | object | `{"release":"prometheus-operator","serviceapp":"coredns-servicemonitor"}` | Extra labels to add on ServiceMonitor ressources |
| prometheusServiceMonitor.relabelings | object | `{}` | Relabel config for the ServiceMonitor, see: https://coreos.com/operators/prometheus/docs/latest/api.html#relabelconfig |
| prometheusServiceMonitor.scrapeInterval | string | `"15s"` | Target scrape interval set in the ServiceMonitor |
| service.annotations | object | `{"prometheus.io/port":"8000","prometheus.io/scrape":"true"}` | Annotations to add to the Service |
| service.create | bool | `true` | Should a headless Service be installed, targets all instances Deployment (required for ServiceMonitor) |
| service.extraLabels | object | `{}` | Extra labels to add to the Service |
| service.port | int | `8000` | TCP port to expose the Service on |
| swift.domain | string | `"Default"` | Swift domain |
| swift.project | string | `nil` | The Swift project  |
| swift.project_domain | string | `"Default"` | Swift project domain |
| swift.url | string | `nil` | A Swift authentication url to target |
| swift.usr | string | `nil` | A Swift user  |
| swiftExporter.nodeSelector | object | `{}` | Node selector for Pods of the Swift Exporter |
| swiftExporter.podAnnotations | object | `{}` | Annotations added to Pods of the Swift Exporter |
| swiftExporter.podExtraLabels | object | `{}` | Extra labels added to Pods of the Swift Exporter |
| swiftExporter.podSecurityContext | object | `{}` | PodSecurityContext for Pods of the Swift Exporter |
| swiftExporter.replicas | int | `1` | Desired number of Swift Exporter Pod |
| swiftExporter.resources | object | see values.yaml | ResourceRequirements for containers of the Swift Exporter |
| swiftExporter.restartPolicy | string | `"Always"` | restartPolicy for Pods of the Swift Exporter |
| swiftExporter.securityContext | object | see values.yaml | SecurityContext for containers of the Swift Exporter |

