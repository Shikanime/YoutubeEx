#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

release_ctl eval --mfa "YoutubeEx.ReleaseTasks.seed/1" --argv -- "$@"
