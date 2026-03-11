#!/bin/sh

set -e

mkdir -p /fontes/apache
rm -rf /fontes/apache/*

cp -R /fontes/sei /fontes/apache/
cp -R /fontes/sip /fontes/apache/
cp -R /fontes/infra /fontes/apache/


##########
# APACHE
##########

echo "Deletando arquivos php /sei"

find /fontes/apache/sei \( -name '*.php'\
        -o -name '*.dat'\
        -o -name 'jodconverter-4.4.8.zip'\
        -o -name 'pdfboxmerge.jar'\
        -o -name 'bcmail-jdk15-1.45.jar'\
        -o -name 'bcprov-jdk15-1.45.jar'\
        -o -name 'verify-1.1.jar' \) -delete

echo "Deletando arquivos php /opt/sip"

find /fontes/apache/sip \( -name '*.php' -o -name '*.dat' \) -delete

echo "Deletando arquivos php /opt/infra"

find /fontes/apache/infra \( -name '*.php' -o -name '*.dat' \) -delete

cp /fontes/sei/web/index.php /fontes/apache/sei/web/
cp /fontes/sip/web/index.php /fontes/apache/sip/web/

echo "Deletando dirs vazios"
find /fontes/apache/sei -type d -empty -delete
find /fontes/apache/sip -type d -empty -delete
find /fontes/apache/infra -type d -empty -delete


###############
# PHP
###############

mkdir -p /fontes/php
rm -rf /fontes/php/*

cp -R /fontes/sei /fontes/php/
cp -R /fontes/sip /fontes/php/
cp -R /fontes/infra /fontes/php/

sed -i "s|\$strServidor = ConfiguracaoSEI::getInstance()->getValor('SEI', 'URL');|if \
        (\$_SERVER['HTTP_HOST'] == 'web' ) {\
        \$strServidor = 'http://web/sei';\
        } else {\
        \$strServidor = ConfiguracaoSEI::getInstance()->getValor('SEI', 'URL');\
        }|g" /fontes/php/sei/web/controlador_ws.php

sed -i "s|\$strServidor = str_replace|; //\$strServidor = str_replace|g" \
        /fontes/php/sei/web/controlador_ws.php

sed -i "s|\$strServidor = ConfiguracaoSip::getInstance()->getValor('Sip', 'URL');|if \
        (\$_SERVER['HTTP_HOST'] == 'web' ) {\
        \$strServidor = 'http://web/sip';\
        } else {\
        \$strServidor = ConfiguracaoSip::getInstance()->getValor('Sip', 'URL');\
        }|g" /fontes/php/sip/web/controlador_ws.php

sed -i "s|if (\$this->isBolRequerHttps()|if (\$this->isBolRequerHttps() \&\& \
      !isset(\$_SERVER['HTTP_X_FORWARDED_FOR'])|" /fontes/php/infra/infra_php/InfraPagina.php

\cp /assets/conf/sei/ConfiguracaoSEI.php /fontes/php/sei/config/
\cp /assets/conf/sei/ConfiguracaoSip.php /fontes/php/sip/config/
#\cp /assets/conf/sei/modulos/ConfiguracaoModAssinaturaEletronica.php /fontes/php/sei/config/mod-assinatura-eletronica/

rm -rf /fontes/php/sei/scripts/*
rm -rf /fontes/php/sip/scripts/*

echo "Deletando arquivos php /fontes/php/sei"

find /fontes/php/sei -type f ! -name "*.php" \
    ! -name "*.wsdl" \
    ! -name "*.dat" \
    ! -name "*.ttf" \
    ! -name "pdfboxmerge.jar" \
    ! -name "bcmail-jdk15-1.45.jar" \
    ! -name "bcprov-jdk15-1.45.jar" \
    ! -name "certificadora.csr" \
    ! -name "verify-1.1.jar" \
    -delete

echo "Deletando arquivos php /fontes/php/sip"

find /fontes/php/sip -type f ! -name "*.php" ! -name "*.wsdl" \
    ! -name "*.dat" ! -name "*.ttf" -delete

echo "Deletando arquivos php /fontes/php/infra"
find /fontes/php/infra -type f ! -name "*.php" ! -name "*.wsdl" \
    ! -name "*.dat" ! -name "*.ttf" -delete

\cp -R /fontes/infra/infra_php/captcha /fontes/php/infra/infra_php/

echo "Deletando disr vazios"
find /fontes/php/sei -type d -empty -delete
find /fontes/php/sip -type d -empty -delete
find /fontes/php/infra -type d -empty -delete

mkdir -p /fontes/scripts/sei/scripts
mkdir -p /fontes/scripts/sip/scripts
rm -rf /fontes/scripts/sei/scripts/*
rm -rf /fontes/scripts/sip/scripts/*
\cp -R /fontes/sei/scripts/* /fontes/scripts/sei/scripts/
\cp -R /fontes/sip/scripts/* /fontes/scripts/sip/scripts/

rm -rf /fontes/infra
rm -rf /fontes/sei
rm -rf /fontes/sip