#!/bin/sh
set -e
cd "$(dirname "$0")"
find . ! -name 'generate-certs.sh' ! -name 'rmcerts.sh' -type f -exec rm {} +
