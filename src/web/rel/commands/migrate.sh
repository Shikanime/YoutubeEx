#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

release_ctl eval --mfa "YoutubeEx.ReleaseTasks.migrate/1" --argv -- "$@"
