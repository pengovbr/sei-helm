################################################################################
# Dockerfile de construcao do container Solr utilizado pelo SEI
#
# Container preparado e configurado para uso em desenvolvimento e testes
################################################################################

ARG IMAGE_SOLR_BASE=rodepelomakefile
ARG IMAGE_SOLR_BASE_VERSION=rodepelomakefile

FROM ${IMAGE_SOLR_BASE}:${IMAGE_SOLR_BASE_VERSION}

ARG DATA=/var/solr/data
ARG CONF=/opt/solr-9.6.1/server/solr/configsets/sample_techproducts_configs/conf/*


USER root

RUN --mount=type=bind,source=assets,target=/temp/,readonly \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    ttf-mscorefonts-installer && \
    fc-cache -f && \
    rm -rf /var/lib/apt/lists/* && \
    cp -R /temp/probes / && \
    chmod +x /probes/*

USER solr

RUN --mount=type=bind,source=assets,target=/temp/,readonly \
   mkdir -p ${DATA} && \
   mkdir -p ${DATA}/sei-protocolos/conf && \
   mkdir -p ${DATA}/sei-bases-conhecimento/conf && \
   mkdir -p ${DATA}/sei-publicacoes/conf && \
   cp -R ${CONF} ${DATA}/sei-protocolos/conf/ && \
   cp -R ${CONF} ${DATA}/sei-bases-conhecimento/conf/ && \
   cp -R ${CONF} ${DATA}/sei-publicacoes/conf/ && \
   \cp -R /temp/sei-cores-9.6.1/* ${DATA}/ && \
   cp /temp/security.json ${DATA}/

