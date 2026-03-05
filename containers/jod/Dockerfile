ARG IMAGE_ALPINE=rodepelomakefile
ARG IMAGE_ALPINE_VERSION=rodepelomakefile

# *****************************************************************
# APACHE **********************************************************
# *****************************************************************

FROM ${IMAGE_ALPINE}:${IMAGE_ALPINE_VERSION} AS apache

ARG JODLOC=https://github.com/pengovbr/sei-docker-binarios/raw/refs/heads/main/pacoteslinux/jodconverter-4.4.8.jar

RUN --mount=type=bind,source=assets,target=/temp/,readonly \
    mkdir -p /opt/app/ && \
    cp /temp/application.yaml /opt/app/ && \
    wget -P /opt/app/ ${JODLOC} && \
    adduser -S jod && \
    chown -R jod /opt/app && \
    # packages
    apk add -f --no-cache \
        libreoffice \
        openjdk17-jdk \
        font-terminus \
        font-inconsolata \
        font-dejavu \
        font-noto \
        font-noto-cjk \
        font-awesome \
        font-noto-extra \
        fontconfig \
        freetype \
        ttf-dejavu \
        ttf-droid \
        ttf-freefont \
        ttf-liberation && \
    # more fonts
    apk add --no-cache --virtual .build-deps \
        msttcorefonts-installer && \
    # Install microsoft fonts
    update-ms-fonts && \
    fc-cache -f && \
    # Clean up when done
    rm -rf /tmp/* && \
    apk del .build-deps

WORKDIR /opt/app

USER jod

CMD java -jar jodconverter-4.4.8.jar