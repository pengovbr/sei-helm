#!/bin/bash

set -e

if [ -z "$APP_FONTES_GIT_PATH" ] || \
   [ -z "$APP_FONTES_GIT_PRIVKEY_BASE64" ] || \
   [ -z "$APP_FONTES_GIT_CHECKOUT" ]; then
    
    echo "Vamos verificar se o fonte existe"
    
    while [ ! -f /opt/sei/web/SEI.php ] || [ ! -f /opt/sip/web/Sip.php ] 
    do
        echo "Codigo fonte do sei  ou sip nao encontrado ou sem permissao."
        echo "Posicione as pastas infra sei e sip no volume vol-sei-fontes"
        echo "Retire antes o ConfiguracaoSEI.php e ConfiguracaoSip.php"
        echo "Aguardando os fontes estarem disponiveis"
        sleep 10
        
    done
    
    
else
    echo "Vamos tentar baixar o fonte do git com os parametros fornecidos"
fi