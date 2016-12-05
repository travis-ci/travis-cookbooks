#!/bin/sh
CQLSHLIB_DIR="$(find /usr/lib -name cqlshlib | head -1)"
if [ -n "${CQLSHLIB_DIR}" ]; then
  CQLSHLIB_PYTHONPATH_ENTRY="$(dirname "${CQLSHLIB_DIR}")"
  if [[ -z "$(echo "${PYTHONPATH}" | tr ':' "\n" | grep "${CQLSHLIB_PYTHONPATH_ENTRY}")" ]]; then
    PYTHONPATH="${PYTHONPATH}:${CQLSHLIB_PYTHONPATH_ENTRY}"
    export PYTHONPATH
  fi
fi
