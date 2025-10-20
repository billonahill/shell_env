#!/bin/bash
set -xe

if [ -z "$1" ]; then
  echo "Usage: $0 <pod_name> [-n <namespace>]"
  echo "Opens a shell on a running k8s pod"
  exit -1
fi

POD=$1
shift # pops off $1. makes $2 -> $1, $3 -> $2, etc
kubectl exec --stdin --tty -u root $POD $@ -- /bin/bash || kubectl exec --stdin --tty $POD $@ -- /bin/bash
