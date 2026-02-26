
ARG IMAGE_ALPINE=rodepelomakefile
ARG IMAGE_ALPINE_VERSION=rodepelomakefile

# *****************************************************************
# APACHE **********************************************************
# *****************************************************************

FROM ${IMAGE_ALPINE}:${IMAGE_ALPINE_VERSION} AS apache

RUN apk add --no-cache \
    apache2 \
    apache2-http2 \
    apache2-proxy

RUN --mount=type=bind,source=assets,target=/temp/,readonly \
    cp /temp/conf/apache/sei.conf /etc/apache2/conf.d/zzz-sei.conf && \
    chown apache:apache /var/www/logs/ && \
    chown -R apache:apache /var/run/apache2 && \
    sed -i 's|#LoadModule mpm_event_module modules/mod_mpm_event.so|LoadModule mpm_event_module modules/mod_mpm_event.so|' /etc/apache2/httpd.conf && \
    sed -i 's|LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|' /etc/apache2/httpd.conf

RUN --mount=type=bind,source=assets,target=/temp/,readonly \
    cp -R /temp/fontes/sei /opt/ && \
    cp -R /temp/fontes/sip /opt/ && \
    cp -R /temp/fontes/infra /opt/ && \
    echo "Deletando arquivos php /opt/sei" && \
    find /opt/sei \( -name '*.php' -o -name '*.dat' -o -name 'jodconverter-4.4.8.zip' -o -name 'pdfboxmerge.jar' \) -delete && \
    echo "Deletando arquivos php /opt/sip" && \
    find /opt/sip \( -name '*.php' -o -name '*.dat' \) -delete && \
    echo "Deletando arquivos php /opt/infra" && \
    find /opt/infra \( -name '*.php' -o -name '*.dat' \) -delete && \
    echo "Deletando disr vazios" && \
    find /opt/sei -type d -empty -delete && \
    find /opt/sip -type d -empty -delete && \
    find /opt/infra -type d -empty -delete && \
    chown -R apache:apache \
        /opt/sei \
        /opt/sip \
        /opt/infra


USER apache

EXPOSE 80

CMD ["httpd", "-DFOREGROUND"]


# *****************************************************************
# PHP *************************************************************
# *****************************************************************

FROM ${IMAGE_ALPINE}:${IMAGE_ALPINE_VERSION} AS php

# Erro do iconv com musl ASCII//TRANSLIT
# https://github.com/docker-library/php/issues/1495
RUN apk add --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/v3.12/community/ \
    gnu-libiconv=1.15-r2;

ENV LD_PRELOAD=/usr/lib/preloadable_libiconv.so

RUN apk add --no-cache \
    php82-bcmath \
    php82-bz2 \
    php82-calendar \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-fpm \
    php82-gd \
    php82-gettext \
    php82-gmp \
    php82-iconv \
    php82-imap \
    php82-intl \
    php82-ldap \
    php82-mbstring \
    php82-mysqli \
    php82-odbc \
    php82-opcache \
    php82-openssl \
    php82-pcntl \
    php82-pdo \
    php82-pdo_mysql \
    php82-pear \
    php82-pecl-apcu \
    php82-pecl-igbinary \
    php82-pecl-mcrypt \
    php82-pecl-memcache \
    php82-phar \
    php82-pspell \
    php82-simplexml \
    php82-sodium \
    php82-shmop \
    php82-snmp \
    php82-soap \
    php82-xml \
    php82-zip \
    php82-zlib \
    php82-pecl-uploadprogress \
    # Suporte para módulo de assinatura avançada
    php82-tokenizer \
    php82-xmlwriter \
    # Pacotes para o wkhtmltopdf
    libstdc++ \
    libx11 \
    libxrender \
    libxext \
    libssl3 \
    ca-certificates \
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

# wkhtmltopdf #
COPY --from=surnet/alpine-wkhtmltopdf:3.22.0-0.12.6-small \
    /bin/wkhtmltopdf /bin/wkhtmltopdf

RUN apk add --no-cache openjdk8

# Geração de audio do captcha
RUN apk add --no-cache ffmpeg;

RUN --mount=type=bind,source=assets,target=/temp/,readonly \
    adduser -u 82 -D -S -G www-data www-data && \
    cp /temp/conf/php/sei.ini /etc/php82/conf.d/zzz-sei.ini && \
    cp /temp/conf/php/sei-fpm.conf /etc/php82/php-fpm.d/zzz-sei-fpm.conf && \
    ln -s /usr/bin/php82 /usr/bin/php

RUN --mount=type=bind,source=assets,target=/temp/,readonly \
    cp -a /temp/fontes/sei /opt/ && \
    cp -a /temp/fontes/sip /opt/ && \
    cp -a /temp/fontes/infra /opt/ && \
    \cp /temp/conf/sei/ConfiguracaoSEI.php /opt/sei/config/ && \
    \cp /temp/conf/sei/ConfiguracaoSip.php /opt/sip/config/ && \
    \cp /temp/conf/sei/modulos/ConfiguracaoModAssinaturaEletronica.php /opt/sei/config/mod-assinatura-eletronica/ && \
    echo "Deletando arquivos php /opt/sei" && \
    find /opt/sei -type f ! -name "*.php" ! -name "*.wsdl" ! -name "*.dat" ! -name "pdfboxmerge.jar" -delete && \
    echo "Deletando arquivos php /opt/sip" && \
    find /opt/sip -type f ! -name "*.php" ! -name "*.wsdl" ! -name "*.dat" -delete && \
    echo "Deletando arquivos php /opt/infra" && \
    find /opt/infra -type f ! -name "*.php" ! -name "*.wsdl" ! -name "*.dat" -delete && \
    echo "Deletando disr vazios" && \
    find /opt/sei -type d -empty -delete && \
    find /opt/sip -type d -empty -delete && \
    find /opt/infra -type d -empty -delete && \
    mkdir -p /sei/arquivos && \
    chown www-data /sei/arquivos && \
    mkdir -p /sei/temp && \
    chown www-data /sei/temp && \
    ln -s /sei/temp /opt/sei/temp && \
    ln -s /sei/temp /opt/sip/temp && \
    mkdir -p /opt/sip/temp && \
    chown www-data /opt/sei/temp && \
    chown www-data /opt/sip/temp

USER www-data

STOPSIGNAL SIGQUIT

EXPOSE 9000

CMD ["php-fpm82"]


# *****************************************************************
# APACHE PHP*******************************************************
# *****************************************************************

FROM php AS apachephp

USER root

RUN apk add --no-cache \
    apache2 \
    apache2-http2 \
    apache2-proxy

RUN --mount=type=bind,source=assets,target=/temp/,readonly \
    cp /temp/conf/apache/sei.conf /etc/apache2/conf.d/sei.conf && \
    chown apache:apache /var/www/logs/ && \
    chown -R apache:apache /var/run/apache2 && \
    sed -i 's|#LoadModule mpm_event_module modules/mod_mpm_event.so|LoadModule mpm_event_module modules/mod_mpm_event.so|' /etc/apache2/httpd.conf && \
    sed -i 's|LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|' /etc/apache2/httpd.conf && \
    sed -i 's|SetHandler "proxy:fcgi://php:9000"|SetHandler "proxy:fcgi://127.0.0.1:9000"|' /etc/apache2/conf.d/sei.conf

RUN --mount=type=bind,from=apache,source=/opt,target=/temp/,readonly \
    \cp -R /temp/sei /opt/ && \
    \cp -R /temp/sip /opt/ && \
    \cp -R /temp/infra /opt/ && \
    chown -R apache:apache \
        /opt/sei \
        /opt/sip \
        /opt/infra

USER apache

EXPOSE 80

CMD ["/bin/sh", "-c", "php-fpm82 -D && httpd -DFOREGROUND"]