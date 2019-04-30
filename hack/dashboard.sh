#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

PROJECT_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
source "${PROJECT_ROOT}/hack/lib/web-ui-dashboard.sh"

web-ui-dashboard::install
