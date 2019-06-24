#!/usr/bin/env bash

set -o errexit
set -o pipefail

release_ctl eval --mfa "Api.ReleaseTasks.migrate/1" --argv -- "$@"
