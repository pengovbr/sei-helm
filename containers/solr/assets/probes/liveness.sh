#!/bin/bash

set -e;

AUTH=${SOLR_PROBE_USER}:${SOLR_PROBE_PASS}

URL=http://localhost:8983/solr/admin/info/system

curl -s --connect-timeout 15000 --user ${AUTH} "${URL}" | \
    grep -q '\"status\":0'

exit 0
