#!/bin/sh

set -e

rm -rf /fontes-sei/sei/config/ConfiguracaoSEI.exemplo.php
rm -rf /fontes-sei/sei/config/ConfiguracaoSEI.testes.php
rm -rf /fontes-sei/sip/config/ConfiguracaoSip.exemplo.php
rm -rf /fontes-sei/sip/config/ConfiguracaoSip.testes.php
rm -rf /fontes-sei/sei/config/mod-pen/ConfiguracaoModPEN.exemplo.php
rm -rf /fontes-sei/sei/config/mod-assinatura-eletronica/ConfiguracaoModAssinaturaEletronica.exemplo.php


mkdir -p /fontes-prepared/apache
rm -rf /fontes-prepared/apache/*

cp -R /fontes-sei/sei /fontes-prepared/apache/
cp -R /fontes-sei/sip /fontes-prepared/apache/
cp -R /fontes-sei/infra /fontes-prepared/apache/


##########
# APACHE
##########

echo "Deletando arquivos php /sei"

find /fontes-prepared/apache/sei \( -name '*.php'\
        -o -name '*.dat'\
        -o -name 'jodconverter-4.4.8.zip'\
        -o -name 'pdfboxmerge.jar'\
        -o -name 'bcmail-jdk15-1.45.jar'\
        -o -name 'bcprov-jdk15-1.45.jar'\
        -o -name 'verify-1.1.jar' \) -delete

echo "Deletando arquivos php /opt/sip"

find /fontes-prepared/apache/sip \( -name '*.php' -o -name '*.dat' \) -delete

echo "Deletando arquivos php /opt/infra"

find /fontes-prepared/apache/infra \( -name '*.php' -o -name '*.dat' \) -delete

cp /fontes-sei/sei/web/index.php /fontes-prepared/apache/sei/web/
cp /fontes-sei/sip/web/index.php /fontes-prepared/apache/sip/web/

echo "Deletando dirs vazios"
find /fontes-prepared/apache/sei -type d -empty -delete
find /fontes-prepared/apache/sip -type d -empty -delete
find /fontes-prepared/apache/infra -type d -empty -delete


###############
# PHP
###############

mkdir -p /fontes-prepared/php
rm -rf /fontes-prepared/php/*

cp -R /fontes-sei/sei /fontes-prepared/php/
cp -R /fontes-sei/sip /fontes-prepared/php/
cp -R /fontes-sei/infra /fontes-prepared/php/

sed -i "s|\$strServidor = ConfiguracaoSEI::getInstance()->getValor('SEI', 'URL');|if \
        (\$_SERVER['HTTP_HOST'] == 'web' ) {\
        \$strServidor = 'http://web/sei';\
        } else {\
        \$strServidor = ConfiguracaoSEI::getInstance()->getValor('SEI', 'URL');\
        }|g" /fontes-prepared/php/sei/web/controlador_ws.php

sed -i "s|\$strServidor = str_replace|; //\$strServidor = str_replace|g" \
        /fontes-prepared/php/sei/web/controlador_ws.php

sed -i "s|\$strServidor = ConfiguracaoSip::getInstance()->getValor('Sip', 'URL');|if \
        (\$_SERVER['HTTP_HOST'] == 'web' ) {\
        \$strServidor = 'http://web/sip';\
        } else {\
        \$strServidor = ConfiguracaoSip::getInstance()->getValor('Sip', 'URL');\
        }|g" /fontes-prepared/php/sip/web/controlador_ws.php

sed -i "s|if (\$this->isBolRequerHttps()|if (\$this->isBolRequerHttps() \&\& \
      !isset(\$_SERVER['HTTP_X_FORWARDED_FOR'])|" /fontes-prepared/php/infra/infra_php/InfraPagina.php

\cp /assets/conf/sei/ConfiguracaoSEI.php /fontes-prepared/php/sei/config/
\cp /assets/conf/sei/ConfiguracaoSip.php /fontes-prepared/php/sip/config/
\cp /assets/conf/sei/modulos/ConfiguracaoModPEN.php /fontes-prepared/php/sei/config/mod-pen/
\cp /assets/conf/sei/modulos/ConfiguracaoModAssinaturaEletronica.php /fontes-prepared/php/sei/config/mod-assinatura-eletronica/

rm -rf /fontes-prepared/php/sei/scripts/*
rm -rf /fontes-prepared/php/sip/scripts/*

echo "Deletando arquivos php /fontes-prepared/php/sei"

find /fontes-prepared/php/sei -type f ! -name "*.php" \
    ! -name "*.wsdl" \
    ! -name "*.dat" \
    ! -name "*.ttf" \
    ! -name "pdfboxmerge.jar" \
    ! -name "bcmail-jdk15-1.45.jar" \
    ! -name "bcprov-jdk15-1.45.jar" \
    ! -name "certificadora.csr" \
    ! -name "verify-1.1.jar" \
    -delete

echo "Deletando arquivos php /fontes-prepared/php/sip"

find /fontes-prepared/php/sip -type f ! -name "*.php" ! -name "*.wsdl" \
    ! -name "*.dat" ! -name "*.ttf" -delete

echo "Deletando arquivos php /fontes-prepared/php/infra"
find /fontes-prepared/php/infra -type f ! -name "*.php" ! -name "*.wsdl" \
    ! -name "*.dat" ! -name "*.ttf" -delete

\cp -R /fontes-sei/infra/infra_php/captcha /fontes-prepared/php/infra/infra_php/
\cp /fontes-sei/sei/web/modulos/assinatura-eletronica/js/*.js /fontes-prepared/php/sei/web/modulos/assinatura-eletronica/js/


echo "Deletando dirs vazios"
find /fontes-prepared/php/sei -type d -empty -delete
find /fontes-prepared/php/sip -type d -empty -delete
find /fontes-prepared/php/infra -type d -empty -delete

echo "Copiando arquivos novos e deletando fontes iniciais"

mkdir -p /fontes-prepared/scripts/sei/scripts
mkdir -p /fontes-prepared/scripts/sip/scripts
rm -rf /fontes-prepared/scripts/sei/scripts/*
rm -rf /fontes-prepared/scripts/sip/scripts/*
\cp -R /fontes-sei/sei/scripts/* /fontes-prepared/scripts/sei/scripts/
\cp -R /fontes-sei/sip/scripts/* /fontes-prepared/scripts/sip/scripts/
