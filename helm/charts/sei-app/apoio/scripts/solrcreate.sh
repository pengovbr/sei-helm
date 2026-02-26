#!/bin/bash

set -e

SOLRUSER="${SOLRADMINUSER}"
SOLRPASS="${SOLRADMINPASS}"
SOLRID=$( echo -n "${ID_INSTALACAO}" | tr '[:upper:]' '[:lower:]' )

CORE_PROTOCOLOS=${SOLRID}-sei-protocolos
CORE_PUBLICACOES=${SOLRID}-sei-publicacoes
CORE_CONHECIMENTO=${SOLRID}-sei-bases-conhecimento

e=1
while [ ! "$e" == "0" ]
do
    echo "Tentando acesso ao solr. Aguarde..."
    set +e
    curl http://${SOLRUSER}:${SOLRPASS}@solrinterno:8983/solr
    e=$?    
    set -e
    sleep 5
        
done

echo "Criando indices do Solr"

if [ ! -d /dados/${CORE_PROTOCOLOS} ]; then
    
    cp -R /dados/sei-protocolos /dados/${CORE_PROTOCOLOS}/
    rm -rf /dados/${CORE_PROTOCOLOS}/core.properties
    chown -R 1000:1000 /dados/${CORE_PROTOCOLOS}/

    curl http://${SOLRUSER}:${SOLRPASS}@solrinterno:8983/solr/admin/cores\?action\=CREATE\&name\=${CORE_PROTOCOLOS}\&instanceDir\=/dados/${CORE_PROTOCOLOS}\&config\=solrconfig.xml\&dataDir\=/dados/${CORE_PROTOCOLOS}/conteudo

else
    
    echo "Indice ja existe no disco"

fi

if [ ! -d /dados/${CORE_PUBLICACOES} ]; then
    
    cp -R /dados/sei-protocolos /dados/${CORE_PUBLICACOES}/
    rm -rf /dados/${CORE_PUBLICACOES}/core.properties
    chown -R 1000:1000 /dados/${CORE_PUBLICACOES}/

    curl http://${SOLRUSER}:${SOLRPASS}@solrinterno:8983/solr/admin/cores\?action\=CREATE\&name\=${CORE_PUBLICACOES}\&instanceDir\=/dados/${CORE_PUBLICACOES}\&config\=solrconfig.xml\&dataDir\=/dados/${CORE_PUBLICACOES}/conteudo

else
    
    echo "Indice ja existe no disco"

fi

if [ ! -d /dados/${CORE_CONHECIMENTO} ]; then
    
    cp -R /dados/sei-protocolos /dados/${CORE_CONHECIMENTO}/
    rm -rf /dados/${CORE_CONHECIMENTO}/core.properties
    chown -R 1000:1000 /dados/${CORE_CONHECIMENTO}/

    curl http://${SOLRUSER}:${SOLRPASS}@solrinterno:8983/solr/admin/cores\?action\=CREATE\&name\=${CORE_CONHECIMENTO}\&instanceDir\=/dados/${CORE_CONHECIMENTO}\&config\=solrconfig.xml\&dataDir\=/dados/${CORE_CONHECIMENTO}/conteudo

else
    
    echo "Indice ja existe no disco"

fi

echo "Apagando Documentos do Solr para o ${ID_INSTALACAO}"

curl --user ${SOLRUSER}:${SOLRPASS} http://solrinterno:8983/solr/${CORE_PROTOCOLOS}/update?commit=true -H "Content-Type: text/xml" \
    --data-binary '<delete><query>*:*</query></delete>'

curl --user ${SOLRUSER}:${SOLRPASS} http://solrinterno:8983/solr/${CORE_CONHECIMENTO}/update?commit=true -H "Content-Type: text/xml" \
    --data-binary '<delete><query>*:*</query></delete>'

curl --user ${SOLRUSER}:${SOLRPASS} http://solrinterno:8983/solr/${CORE_PUBLICACOES}/update?commit=true -H "Content-Type: text/xml" \
    --data-binary '<delete><query>*:*</query></delete>'

