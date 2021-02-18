#! /bin/sh

set -e

apk add screen openssh
sed -i "s/-D -e -p 2222/-D -e -p $1/g" /etc/services.d/openssh-server/run
cat /var/run/secrets/kubernetes.io/serviceaccount/token | cut -c1-255 | tr -d $'\n' > /config/password

/init
