ARG IMAGE_ALPINE=xxx
ARG IMAGE_ALPINE_VERSION=xxx

FROM ${IMAGE_ALPINE}:${IMAGE_ALPINE_VERSION}

# Variáveis de ambiente
ENV PHP_VERSION=82 \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp/composer

# Instalação de dependências necessárias para o build
RUN apk add --no-cache \
    php${PHP_VERSION} \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-zlib \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-xmlwriter \
    composer \
    git \
    make \
    zip \
    unzip