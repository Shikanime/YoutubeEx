#!/usr/bin/env bash

set -o errexit
set -o pipefail

release_ctl eval --mfa "YoutubeEx.ReleaseTasks.migrate/1" --argv -- "$@"
