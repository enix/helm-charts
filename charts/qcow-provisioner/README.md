# QCOW provisioner for Kubernetes

Local path provisioner for Kubernetes that move volumes between nodes when pods get re-scheduled. Stores volumes as QCOW2 images.

### ⛔️ Disclaimer : Monkeys are doing experiments ⛔️

This project is under active development and such **IS NOT SUITABLE FOR PRODUCTION**. Use it at your own risk :^)

## Installation

Installation can be done using the [provided Helm chart](https://github.com/enix/helm-charts/tree/master/charts/qcow-provisioner).

```bash
helm repo add enix https://charts.enix.io
helm repo update
helm install qcow-provisioner enix/qcow-provisioner
```

## Configuration

All the configuration is done when deploying the Helm chart.
There is no configuration in the StorageClass so it is created automatically.

Make sure to set `kubeletPath` to the appropriate location. If using RancherOS, it should be set to "`/opt/rke/var/lib/kubelet`".

```
$ cat helm/values.yaml

kubeletPath: /var/lib/kubelet
verbosity: 4
maxVolumesPerNode: 256
```

## Usage

Create PVC(s) with `storageClassName: qcow.csi.enix.io`, e.g. :

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: claim

spec:
  storageClassName: qcow.csi.enix.io
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
