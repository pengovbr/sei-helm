#!/bin/bash

set -e

{{- if not .Values.app.install.solr.enable }}
echo "Chave para instalacao inicial dos indices solr = false."
echo "Nao vamos criar os indices. Crie-os manualmente..."
exit 0
{{ end }}

SOLRUSER="{{ .Values.app.solrAdminUser }}"
SOLRPASS="{{ .Values.app.solrAdminPass }}"

CORE_PROTOCOLOS="{{ .Values.app.install.solr.idxProtocolo }}"
CORE_PUBLICACOES="{{ .Values.app.install.solr.idxPublicacoes }}"
CORE_CONHECIMENTO="{{ .Values.app.install.solr.idxBaseConhecimento }}"

e=1
while [ ! "$e" == "0" ]
do
    echo "Tentando acesso ao solr. Aguarde..."
    set +e
    curl http://${SOLRUSER}:${SOLRPASS}@solr:8983/solr
    e=$?
    set -e
    sleep 5

done

echo "Criando indices do Solr e na sequencia usuario do solr"
echo "Criando indice de protocolos"
if [ ! -d /var/solr/data/${CORE_PROTOCOLOS} ]; then

    cp -R /var/solr/data/sei-protocolos /var/solr/data/${CORE_PROTOCOLOS}/
    rm -rf /var/solr/data/${CORE_PROTOCOLOS}/core.properties
    chown -R 8983:8983 /var/solr/data/${CORE_PROTOCOLOS}/

    curl http://${SOLRUSER}:${SOLRPASS}@solr:8983/solr/admin/cores\?action\=CREATE\&name\=${CORE_PROTOCOLOS}\&instanceDir\=/var/solr/data/${CORE_PROTOCOLOS}\&config\=solrconfig.xml\&dataDir\=/var/solr/data/${CORE_PROTOCOLOS}/conteudo

else

    echo "Indice ja existe no disco"

fi

echo "Criando indice de publicacoes"
if [ ! -d /var/solr/data/${CORE_PUBLICACOES} ]; then

    cp -R /var/solr/data/sei-protocolos /var/solr/data/${CORE_PUBLICACOES}/
    rm -rf /var/solr/data/${CORE_PUBLICACOES}/core.properties
    chown -R 8983:8983 /var/solr/data/${CORE_PUBLICACOES}/

    curl http://${SOLRUSER}:${SOLRPASS}@solr:8983/solr/admin/cores\?action\=CREATE\&name\=${CORE_PUBLICACOES}\&instanceDir\=/var/solr/data/${CORE_PUBLICACOES}\&config\=solrconfig.xml\&dataDir\=/var/solr/data/${CORE_PUBLICACOES}/conteudo

else

    echo "Indice ja existe no disco"

fi

echo "Criando indice de bases de conhecimento"
if [ ! -d /var/solr/data/${CORE_CONHECIMENTO} ]; then

    cp -R /var/solr/data/sei-protocolos /var/solr/data/${CORE_CONHECIMENTO}/
    rm -rf /var/solr/data/${CORE_CONHECIMENTO}/core.properties
    chown -R 8983:8983 /var/solr/data/${CORE_CONHECIMENTO}/

    curl http://${SOLRUSER}:${SOLRPASS}@solr:8983/solr/admin/cores\?action\=CREATE\&name\=${CORE_CONHECIMENTO}\&instanceDir\=/var/solr/data/${CORE_CONHECIMENTO}\&config\=solrconfig.xml\&dataDir\=/var/solr/data/${CORE_CONHECIMENTO}/conteudo

else

    echo "Indice ja existe no disco"

fi

echo "Criando usuario"

curl http://${SOLRUSER}:${SOLRPASS}@solr:8983/solr/admin/authentication \
    -H 'Content-type:application/json' \
    -d '{ "set-user": {"{{ .Values.app.install.solr.username }}": "{{ .Values.app.install.solr.password }}"} }'

curl --user "${SOLRUSER}:${SOLRPASS}" http://solr:8983/solr/admin/authorization \
    -H 'Content-type:application/json' \
    -d '{"set-user-role": {"{{ .Values.app.install.solr.username }}":["basic"]}}'

echo "Usuario criado"
