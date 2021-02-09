#! /bin/bash

set -e

volumeDir="$1"
secret="$2"
remoteAddr="$3"
remotePort="$4"
expectedChecksum="$5"
statusCopying="$6"
statusReady="$7"
statusFailed="$8"

trap "echo ${statusFailed} > ${volumeDir}/status" ERR

mkdir -p ${volumeDir}
mkdir -p "/root/.ssh"
touch "/root/.ssh/known_hosts" > /dev/null || true
ssh-keygen -f "/root/.ssh/known_hosts" -R "[${remoteAddr}]:${remotePort}"  > /dev/null || true

echo ${statusCopying} > ${volumeDir}/status

sshpass -p "${secret}" scp -P ${remotePort} -o StrictHostKeyChecking=no	\
	kube@${remoteAddr}:${volumeDir}/vdisk.qcow2							\
	${volumeDir}/vdisk.qcow2

sha1=$(sha1sum ${volumeDir}/vdisk.qcow2 | awk '{ print $1 }')
if [[ "${sha1}" != "${expectedChecksum}" ]]; then
	echo "failed to copy volume: SHA1 does not match (expected ${expectedChecksum}, got ${sha1})"
	exit 1
fi

echo ${statusReady} > ${volumeDir}/status
