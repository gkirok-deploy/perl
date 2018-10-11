#!/bin/bash

set -e

if [ -f /opt/test.sh ] && [[ "$1" == 'test' ]]; then
  shift
  /bin/bash /opt/test.sh
elif [[ ! -z "$1" ]]; then
  /usr/local/bin/perl /opt/output.pl "$@"
  shift
fi
# allow running any command
# inside the container
exec "$@"