#!/bin/bash

set -e

{{ if not .Values.app.db.criarDatabases }}
echo "Chave para criacao de banco criarDatabases=false."
echo "Nao vamos criar os databases. Provisione-os manualmente"
exit 0
{{ end }}

{{ with .Values.app.db.seiDbName }}
    DBSEI={{ . }}
{{ end }}
{{ with .Values.app.db.sipDbName }}
    DBSIP={{ . }}
{{ end }}

{{ with .Values.app.db.seiUser }}
    SEIUSERNAME={{ . }}
{{ end }}
{{ with .Values.app.db.sipUser }}
    SIPUSERNAME={{ . }}
{{ end }}

{{ with .Values.app.db.seiPassword }}
    SEIPASSWORD={{ . }}
{{ end }}
{{ with .Values.app.db.sipPassword }}
    SIPPASSWORD={{ . }}
{{ end }}


DB_RECREATE="{{ .Values.app.db.apagarDatabases | ternary "true" "false" }}"
APP_DB_HOST="{{ .Values.app.db.db_host }}"
APP_DB_ROOT_USERNAME="{{ .Values.app.db.db_root_username }}"
APP_DB_ROOT_PASSWORD="{{ .Values.app.db.db_root_password }}"

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
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "drop database ${DBSEI};"
    sleep 2
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "drop database ${DBSIP};"
    sleep 2
    set -e
fi

set +e
mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "show databases;" | grep "${DBSEI}"
e=$?
set -e

if [ "$e" == "0" ]; then
    echo "Database ${DBSEI} já existe. Pulando criação."
else
    echo "Aguardando criacao dos databases para o orgao"

    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "create database ${DBSEI};"
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl ${DBSEI} < sei_5_0_0_BD_Ref_Exec.sql
    sleep 2

    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "create database ${DBSIP};"
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl ${DBSIP} < sip_5_0_0_BD_Ref_Exec.sql
    sleep 2

    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "show databases;"

    echo "Databases criados. Aguardando provisionamento dos usuarios..."

    set +e
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "create user ${SEIUSERNAME}@'%' identified by '${SEIPASSWORD}' ;"
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "create user ${SIPUSERNAME}@'%' identified by '${SIPPASSWORD}' ;"
    set -e

    echo "Liberando permissoes aos usuarios do sei e sip."
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "GRANT ALL PRIVILEGES ON ${DBSEI}.* TO ${SEIUSERNAME}@'%' ;"
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "GRANT ALL PRIVILEGES ON ${DBSIP}.* TO ${SIPUSERNAME}@'%' ;"
    mariadb -h ${APP_DB_HOST} -u ${APP_DB_ROOT_USERNAME} -p${APP_DB_ROOT_PASSWORD} --skip-ssl -e "FLUSH PRIVILEGES;"

    echo "Done!"

fi

mkdir -p /var/lib/sei/dbcontrol
touch /var/lib/sei/dbcontrol/bancoinstalado.ok
