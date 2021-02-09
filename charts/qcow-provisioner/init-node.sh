#! /bin/bash

rmmod nbd || echo "WARNING: failed to unload ndb module, could not set nbds_max"
echo modprobe nbd max_part=16 nbds_max=$1
modprobe nbd max_part=16 nbds_max=$1
echo $?
ls /dev | grep nbd
sleep 10
rm -f "$2/plugins/qcow.csi.enix.io/csi.sock"

node -node-name "$QCOW_PROVISIONER_NODE_NAME" ${@:3}
