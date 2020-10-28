#!/bin/sh

set -ex

# enable kernel mod iscsi_tcp
modprobe iscsi_tcp

# generate a unique IQN for the node
if [ ! -f /host/iscsi/initiatorname.iscsi ]; then
	cp /etc/iscsi/* /host/iscsi &&
	sed -re "s/(InitiatorName=).*/\1$(iscsi-iname -p iqn.2013-10.io.enix)/" /etc/iscsi/initiatorname.iscsi > /host/iscsi/initiatorname.iscsi
fi
