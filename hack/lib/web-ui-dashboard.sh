#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

web-ui-dashboard::install() {
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml
}
