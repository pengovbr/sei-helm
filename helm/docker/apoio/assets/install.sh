#!/bin/bash

set -e

yum install -y mysql

mv /tmp/assets/dbcreate.sh /tmp/assets/solrcreate.sh /
chmod +x /dbcreate.sh

mkdir -p /dbref
cd /dbref

URLSEIDMP=https://raw.githubusercontent.com/pengovbr/sei-db-ref-executivo/refs/heads/master/mysql/v5.0.0/sei_5_0_0_BD_Ref_Exec.sql
URLSIPDMP=https://raw.githubusercontent.com/pengovbr/sei-db-ref-executivo/refs/heads/master/mysql/v5.0.0/sip_5_0_0_BD_Ref_Exec.sql

curl -LO ${URLSEIDMP}
curl -LO ${URLSIPDMP}

cd -