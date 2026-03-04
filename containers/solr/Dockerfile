################################################################################
# Dockerfile de construcao do container Solr utilizado pelo SEI
#
# Container preparado e configurado para uso em desenvolvimento e testes
################################################################################

ARG IMAGE_SOLR_BASE=rodepelomakefile
ARG IMAGE_SOLR_BASE_VERSION=rodepelomakefile

FROM ${IMAGE_SOLR_BASE}:${IMAGE_SOLR_BASE_VERSION}

USER root

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    msttcorefonts && \
    #tzdata && \
    rm -rf /var/lib/apt/lists/*

USER solr

RUN --mount=type=bind,source=assets,target=/temp/,readonly \
   mkdir -p /var/solr/data && \
   cp -R /opt/solr-9.6.1/server/solr/configsets/sample_techproducts_configs/conf \
      /var/solr/data/sei-protocolos/ && \
   cp -R /opt/solr-9.6.1/server/solr/configsets/sample_techproducts_configs/conf \
      /var/solr/data/sei-bases-conhecimento/ && \
   cp -R /opt/solr-9.6.1/server/solr/configsets/sample_techproducts_configs/conf \
      /var/solr/data/sei-publicacoes/ && \
   cp -R /temp/sei-cores-9.6.1/* /var/solr/data/ && \
   cp /temp/security.json /var/solr/data/

