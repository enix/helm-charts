kube-router
===========

<p align="center">
    <a href="https://opensource.org/licenses/Apache-2.0" alt="Apache 2.0 License">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a href="https://enix.io/fr/blog/" alt="Brought to you by ENIX">
        <img src="https://img.shields.io/badge/Brought%20to%20you%20by-ENIX-%23377dff?labelColor=888&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAQAAAC1QeVaAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfkBAkQIg/iouK/AAABZ0lEQVQY0yXBPU8TYQDA8f/zcu1RSDltKliD0BKNECYZmpjgIAOLiYtubn4EJxI/AImzg3E1+AGcYDIMJA7lxQQQQRAiSSFG2l457+655x4Gfz8B45zwipWJ8rPCQ0g3+p9Pj+AlHxHjnLHAbvPW2+GmLoBN+9/+vNlfGeU2Auokd8Y+VeYk/zk6O2fP9fcO8hGpN/TUbxpiUhJiEorTgy+6hUlU5N1flK+9oIJHiKNCkb5wMyOFw3V9o+zN69o0Exg6ePh4/GKr6s0H72Tc67YsdXbZ5gENNjmigaXbMj0tzEWrZNtqigva5NxjhFP6Wfw1N1pjqpFaZQ7FAY6An6zxTzHs0BGqY/NQSnxSBD6WkDRTf3O0wG2Ztl/7jaQEnGNxZMdy2yET/B2xfGlDagQE1OgRRvL93UOHqhLnesPKqJ4NxLLn2unJgVka/HBpbiIARlHFq1n/cWlMZMne1ZfyD5M/Aa4BiyGSwP4Jl3UAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjAtMDQtMDlUMTQ6MzQ6MTUrMDI6MDDBq8/nAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIwLTA0LTA5VDE0OjM0OjE1KzAyOjAwsPZ3WwAAAABJRU5ErkJggg==" /></a>
</p>

A turnkey solution for Kubernetes networking with aim to provide operational simplicity and high performance.

<p align="center">
<img src="https://i.giphy.com/media/gLcUG7QiR0jpMzoNUu/giphy.webp" alt="Warning Warning" />
<br />
<strong>This chart is currently released as an alpha quality version. We encourage you to test it but please, do not put it in production. Please No.</strong>
</p>


## TL;DR;

```bash
$ helm repo add enix https://charts.enix.io/
$ helm install my-release enix/kube-router
```

Source code can be found [here](https://www.kube-router.io/)



## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release enix/kube-router
```

The command deploys Kube-Router on the Kubernetes cluster in the default configuration. The [Chart Values](#chart-values) section lists the parameters that can be configured during installation.

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
| fullnameOverride | string | `""` |  String to fully override mosquitto.fullname template with a string |
| image.pullPolicy | string | `"IfNotPresent"` | Kube-Router image pull policy |
| image.repository | string | `"docker.io/cloudnativelabs/kube-router"` | Kube-Router image |
| image.tag | string | `nil` | Override the kube-router image tag |
| imagePullSecrets | list | `[]` | Docker-registry secret names as an array |
| kubeRouter.apiServerUrl | string | `nil` | URL of the API server. If you use Kube-Router as service-proxy, use a reliable way to contact your masters |
| kubeRouter.cacheSyncTimeout | string | `nil` | The timeout for cache synchronization (e.g. '5s', '1m'). Must be greater than 0 |
| kubeRouter.cni.config | string | `"{\n  \"cniVersion\":\"0.3.0\",\n  \"name\":\"mynet\",\n  \"plugins\":[\n      {\n        \"name\":\"kubernetes\",\n        \"type\":\"bridge\",\n        \"bridge\":\"kube-bridge\",\n        \"isDefaultGateway\":true,\n        \"hairpinMode\":true,\n        \"ipam\":{\n            \"type\":\"host-local\"\n        }\n      },\n      {\n        \"type\":\"portmap\",\n        \"capabilities\":{\n            \"snat\":true,\n            \"portMappings\":true\n        }\n      }\n  ]\n}\n"` |  |
| kubeRouter.cni.downloadUrl | string | `"https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-amd64-${CNI_VERSION}.tgz"` |  |
| kubeRouter.cni.install | bool | `false` |  |
| kubeRouter.cni.installPath | string | `"/opt/cni/bin"` |  |
| kubeRouter.cni.version | string | `"v0.7.5"` |  |
| kubeRouter.enablePprof | string | `nil` | Enables pprof for debugging performance and memory leak issues |
| kubeRouter.extraArgs | list | `[]` | Extra arguments to pass to kube-router |
| kubeRouter.firewall.enabled | bool | `true` | Enables Network Policy, sets up iptables to provide ingress firewall for pods |
| kubeRouter.firewall.iptablesSyncPeriod | string | `nil` | The delay between iptables rule synchronizations (e.g. '5s', '1m'). Must be greater than 0 |
| kubeRouter.healthPort | string | `nil` | Health check port, 0 = Disabled |
| kubeRouter.metrics.path | string | `nil` | Prometheus metrics path |
| kubeRouter.metrics.port | string | `nil` | Prometheus metrics port (set 0 to disable) |
| kubeRouter.router.advertiseClusterIp | string | `nil` | Add Cluster IP of the service to the RIB so that it gets advertises to the BGP peers (true or false) |
| kubeRouter.router.advertiseExternalIp | string | `nil` | Add External IP of service to the RIB so that it gets advertised to the BGP peers (true or false) |
| kubeRouter.router.advertiseLoadbalancerIp | string | `nil` | Add LoadbBalancer IP of service status as set by the LB provider to the RIB so that it gets advertised to the BGP peers (true or false) |
| kubeRouter.router.advertisePodCidr | string | `nil` | Add Node's POD cidr to the RIB so that it gets advertised to the BGP peers (true or false) |
| kubeRouter.router.bgpGracefulRestart | string | `nil` | Enables the BGP Graceful Restart capability so that routes are preserved on unexpected restarts |
| kubeRouter.router.bgpGracefulRestartDeferralTime | string | `nil` | BGP Graceful restart deferral time according to RFC4724 4.1, maximum 18h |
| kubeRouter.router.bgpPort | string | `nil` | The port open for incoming BGP connections and to use for connecting with other BGP peers |
| kubeRouter.router.bgpRouterId | string | `nil` | BGP router-id. Must be specified in a ipv6 only cluster |
| kubeRouter.router.clusterAsn | string | `nil` | ASN number under which cluster nodes will run iBGP |
| kubeRouter.router.disableSourceDestCheck | string | `nil` | Disable the source-dest-check attribute for AWS EC2 instances. When this option is false, it must be set some other way (true or false) |
| kubeRouter.router.enableCni | string | `nil` | Enable CNI plugin. Disable if you want to use kube-router features alongside another CNI plugin (true or false) |
| kubeRouter.router.enableIbgp | string | `nil` | Enables peering with nodes with the same ASN, if disabled will only peer with external BGP peers (true or false) |
| kubeRouter.router.enableOverlay | string | `nil` | Enable IP-in-IP tunneling for pod-to-pod networking across nodes in different subnets (true or false) |
| kubeRouter.router.enablePodEgress | string | `nil` | SNAT traffic from Pods to destinations outside the cluster (true or false) |
| kubeRouter.router.enabled | bool | `true` | Enables Pod Networking, Advertises and learns the routes to Pods via iBGP |
| kubeRouter.router.nodesFullMesh | string | `nil` | Each node in the cluster will setup BGP peering with rest of the nodes (true or false) |
| kubeRouter.router.overlayType | string | `nil` | Topology of overlay network. Possible values: subnet or full. |
| kubeRouter.router.overrideNexthop | string | `nil` | Override the next-hop in bgp routes sent to peers with the local ip |
| kubeRouter.router.peerRouterMultihopTtl | string | `nil` | Enable eBGP multihop supports (Relevant only if ttl >= 2) |
| kubeRouter.router.peers | list | `[]` | List of external BGP peers, see values.yaml for example |
| kubeRouter.router.routesSyncPeriod | string | `nil` | The delay between route updates and advertisements (e.g. '5s', '1m', '2h22m'). Must be greater than 0 |
| kubeRouter.serviceProxy.enabled | bool | `false` | Enables Service Proxy, sets up IPVS for Kubernetes Services |
| kubeRouter.serviceProxy.excludedCidrs | string | `nil` | Excluded CIDRs are used to exclude IPVS rules from deletion |
| kubeRouter.serviceProxy.hairpinMode | string | `nil` | Add iptables rules for every Service Endpoint to support hairpin traffic (true or false) |
| kubeRouter.serviceProxy.ipvsGracefulPeriod | string | `nil` | The graceful period before removing destinations from IPVS services (e.g. '5s', '1m', '2h22m'). Must be greater than 0 |
| kubeRouter.serviceProxy.ipvsGracefulTermination | string | `nil` | Enables the experimental IPVS graceful terminaton capability (true or false) |
| kubeRouter.serviceProxy.ipvsPermitAll | string | `nil` | Enables rule to accept all incoming traffic to service VIP's on the node (true or false) |
| kubeRouter.serviceProxy.ipvsSyncPeriod | string | `nil` | The delay between ipvs config synchronizations (e.g. '5s', '1m', '2h22m'). Must be greater than 0 |
| kubeRouter.serviceProxy.masqueradeAll | string | `nil` | SNAT all traffic to cluster IP/node port (true or false) |
| kubeRouter.serviceProxy.nodeportBindonAllIp | string | `nil` | For service of NodePort type create IPVS service that listens on all IP's of the node (true or false) |
| livenessProbe | object | `{"httpGet":{"path":"/healthz","port":20244},"initialDelaySeconds":10,"periodSeconds":3}` | Liveness probe for the kube-router workload |
| nameOverride | string | `""` | String to partially override kube-router.fullname template with a string (will prepend the release name) |
| nodeSelector | object | `{}` | Kube-Router labels for pod assignment |
| readinessProbe | object | `{"exec":{"command":["sh","-c","neighbors=\"$(/usr/local/bin/gobgp neighbor 2>/dev/null | tail -n +2)\"; test $(echo \"$neighbors\" | wc -l) -ge 1; test $(echo \"$neighbors\" | grep -v ' Establ ' | wc -l) -eq 0"]},"initialDelaySeconds":5,"periodSeconds":3}` | Readiness probe for the kube-router workload |
| resources | object | `{"requests":{"cpu":"250m","memory":"250Mi"}}` | CPU/Memory resource requests/limits |
| tolerations | list | `[{"key":"CriticalAddonsOnly","operator":"Exists"},{"effect":"NoSchedule","key":"node-role.kubernetes.io/master","operator":"Exists"},{"effect":"NoSchedule","key":"node.kubernetes.io/not-ready","operator":"Exists"},{"effect":"NoSchedule","key":"node-role.kubernetes.io/controlplane","operator":"Exists"},{"effect":"NoExecute","key":"node-role.kubernetes.io/etcd","operator":"Exists"}]` | Kube-Router labels for tolerations pod assignment |
| updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | Update strategy to use when upgrading workload |

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