#!/usr/bin/env bash

set -o errexit
set -o pipefail

release_ctl eval --mfa "Api.ReleaseTasks.seed/1" --argv -- "$@"
