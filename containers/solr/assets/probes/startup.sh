#!/bin/bash

set -e;

AUTH=${SOLR_PROBE_USER}:${SOLR_PROBE_PASS}

URL=http://localhost:8983/solr/admin/cores\?action\=STATUS\&core\=

curl -s --connect-timeout 15000 --user ${AUTH} "${URL}sei-protocolos" | \
    grep -q "startTime"

curl -s --connect-timeout 15000 --user ${AUTH} "${URL}sei-bases-conhecimento" | \
    grep -q "startTime"

curl -s --connect-timeout 15000 --user ${AUTH} "${URL}sei-publicacoes" | \
    grep -q "startTime"

exit 0