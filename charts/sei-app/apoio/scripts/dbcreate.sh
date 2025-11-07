#!/bin/bash

set -e

DBID=$( echo -n "${ID_INSTALACAO}" | tr '[:upper:]' '[:lower:]' )

cd /dbref

e=1
while [ ! "$e" == "0" ]
do
    
    echo "Vamos tentar conectar no banco e listar as bases. Aguarde banco ficar disponivel."
    set +e
    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "show databases;"
    e=$?
    set -e
    
    sleep 3
done





if [ "$DB_RECREATE" == "true" ]; then 
    echo "Apagando bases caso existam"
    set +e
    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "drop database ${DBID}sei;"
    sleep 2
    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "drop database ${DBID}sip;"
    sleep 2
    set -e
fi

set +e
mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "show databases;" | grep "${DBID}sei"
e=$?
set -e

if [ "$e" == "0" ]; then
    echo "Database ${DBID}sei já existe. Pulando criação."
else
    echo "Aguardando criacao dos databases para o orgao ${DBID}"

    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "create database ${DBID}sei;"
    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} ${DBID}sei < sei_5_0_0_BD_Ref_Exec.sql
    sleep 2

    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "create database ${DBID}sip;"
    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} ${DBID}sip < sip_5_0_0_BD_Ref_Exec.sql
    sleep 2
    
    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "show databases;"

    echo "Databases criados, criando usuarios..."
    
    set +e
    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "create user ${DBID}usei@'%' identified by '${DBID}usei' ;"
    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "create user ${DBID}usip@'%' identified by '${DBID}usip' ;"
    set -e

    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${DBID}sei.* TO ${DBID}usei@'%' ;"
    mysql -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${DBID}sip.* TO ${DBID}usip@'%' ;"
        
fi

cd -

touch /sei/controlador-instalacoes/bancoinstalado.ok
