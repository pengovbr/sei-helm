#!/bin/bash

set -e

DBID=$( echo -n "{{ .Values.app.install.idInstalacao }}" | tr '[:upper:]' '[:lower:]' )
DB_RECREATE="{{ .Values.app.install.db.recreate | ternary "true" "false" }}"
APP_DB_HOST="{{ .Values.app.db_host }}"
APP_DB_ROOT_USERNAME="{{ .Values.app.db_root_username }}"
APP_DB_ROOT_PASSWORD="{{ .Values.app.db_root_password }}"

cd /dbref

e=1
while [ ! "$e" == "0" ]
do

    echo "Vamos tentar conectar no banco e listar as bases. Aguarde banco ficar disponivel."
    set +e
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "show databases;"
    e=$?
    set -e
    sleep 5

done

if [ "$DB_RECREATE" == "true" ]; then
    echo "Apagando bases caso existam"
    set +e
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "drop database ${DBID}sei;"
    sleep 2
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "drop database ${DBID}sip;"
    sleep 2
    set -e
fi

set +e
mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "show databases;" | grep "${DBID}sei"
e=$?
set -e

if [ "$e" == "0" ]; then
    echo "Database ${DBID}sei já existe. Pulando criação."
else
    echo "Aguardando criacao dos databases para o orgao ${DBID}"

    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "create database ${DBID}sei;"
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl ${DBID}sei < sei_5_0_0_BD_Ref_Exec.sql
    sleep 2

    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "create database ${DBID}sip;"
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl ${DBID}sip < sip_5_0_0_BD_Ref_Exec.sql
    sleep 2

    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "show databases;"

    echo "Databases criados, criando usuarios..."

    set +e
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "create user ${DBID}usei@'%' identified by '${DBID}usei' ;"
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "create user ${DBID}usip@'%' identified by '${DBID}usip' ;"
    set -e

    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "GRANT ALL PRIVILEGES ON ${DBID}sei.* TO ${DBID}usei@'%' ;"
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "GRANT ALL PRIVILEGES ON ${DBID}sip.* TO ${DBID}usip@'%' ;"

fi

cd -

mkdir -p /var/lib/sei/dbcontrol
touch /var/lib/sei/dbcontrol/bancoinstalado.ok
