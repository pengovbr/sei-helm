#!/bin/bash

set -e

if [ "${SEI_DOWNLOAD}" == "true" ]; then

    mkdir /opt2
    cd /opt2

    rm -rf /fontes/*
    mkdir -p /fontes/sei \
        /fontes/sip \
        /fontes/infra

    echo "******************************"
    echo "******DOWNLOADING SEI*********"
    echo "******************************"

    git clone https://dummy:${GIT_SEI_PAT}@${GIT_SEI_URL}
    cd sei
    git checkout ${GIT_SEI_VERSION}

    cd src

    cp -R sei/* /fontes/sei/
    cp -R sip/* /fontes/sip/
    cp -R infra/* /fontes/infra/

fi

echo "******************************"
echo "****DOWNLOADING MODULOS*******"
echo "******************************"

if [ "${MODULO_ESTATISTICAS_DOWNLOAD}" == "true" ]; then

    echo "******************************"
    echo "****DOWNLOADING ESTATISTICAS**"
    echo "******************************"

    cd /
    git clone https://dummy:${GIT_SEI_PAT}@${MODULO_ESTATISTICAS_GIT_URL}
    cd mod-sei-estatisticas
    git checkout ${MODULO_ESTATISTICAS_GIT_VERSION}

    mkdir -p /fontes/sei/web/modulos/mod-sei-estatisticas
    \cp -R * /fontes/sei/web/modulos/mod-sei-estatisticas/

    cd /
    rm -rf mod-sei-estatisticas

fi

if [ "${MODULO_PEN_DOWNLOAD}" == "true" ]; then
    echo "******************************"
    echo "****DOWNLOADING PEN***********"
    echo "******************************"

    git clone https://dummy:${GIT_SEI_PAT}@${MODULO_PEN_GIT_URL}
    cd mod-sei-pen
    git checkout ${MODULO_PEN_GIT_VERSION}

    make clean
    make dist
    cd dist
    files=( *.zip )
    f="${files[0]}"
    mkdir -p temp
    cp $f temp/
    cd temp/
    yes | unzip $f
    cp -Rf sei/* /fontes/sei/
    cp -Rf sip/* /fontes/sip/

    cd /
    rm -rf mod-sei-pen
fi

if [ "${MODULO_ASSINATURA_DOWNLOAD}" == "true" ]; then

    echo "******************************"
    echo "****DOWNLOADING ASSINATURA****"
    echo "******************************"

    git clone https://dummy:${GIT_SEI_PAT}@${MODULO_ASSINATURA_GIT_URL}
    cd mod-sei-assinatura-eletronica
    git checkout ${MODULO_ASSINATURA_GIT_VERSION}

    touch docs/changelogs/CHANGELOG-1.3.0.md
    make dist
    cd dist
    files=( *.zip )
    f="${files[0]}"
    mkdir -p temp
    cp $f temp/
    cd temp/
    yes | unzip $f

    cp -Rf sei/* /fontes/sei/
    cp -Rf sip/* /fontes/sip/

    cd /
    rm -rf mod-sei-assinatura-eletronica
fi


if [ "${MODULO_RESPOSTA_DOWNLOAD}" == "true" ]; then

    echo "******************************"
    echo "****DOWNLOADING RESPOSTA******"
    echo "******************************"

    git clone https://dummy:${GIT_SEI_PAT}@${MODULO_RESPOSTA_GIT_URL}
    cd mod-sei-resposta
    git checkout ${MODULO_RESPOSTA_GIT_VERSION}

    make dist
    cd dist
    files=( *.zip )
    f="${files[0]}"
    mkdir -p temp
    cp $f temp/
    cd temp/
    yes | unzip $f

    cp -Rf sei/* /fontes/sei/
    cp -Rf sip/* /fontes/sip/

    cd /
    rm -rf mod-sei-resposta
fi