#!/bin/bash

APP_DB_ROOT_USERNAME="{{ .Values.app.db_root_username }}"
APP_DB_ROOT_PASSWORD="{{ .Values.app.db_root_password }}"

set +e
RET=1
while [ ! "$RET" == "0" ]
do
    echo ""
    echo "Esperando a base de dados ficar disponivel... Vamos tentar chama-la ...."

    php -r "
    require_once '/opt/sip/web/Sip.php';
    \$conexao = BancoSip::getInstance();
    \$conexao->abrirConexao();
    \$conexao->executarSql('select sigla from sistema');"

    RET=$?

    sleep 3

done

set -e


while [ ! -f /var/lib/sei/dbcontrol/install-initial.ok ]; do
    echo 'Aguardando Instalacao Inicial...'
    sleep 2
done


echo "***************************************************"
echo "***************************************************"
echo "*INICIANDO CONFIGURACOES DO MODULO PEN BARRAMENTO**"
echo "***************************************************"
echo "***************************************************"

{{- if .Values.app.modulo_pen_instalar }}

    VERSAO_ENCONTRADA=$(php -r "require_once '/opt/sei/web/SEI.php'; require_once '/opt/sei/web/modulos/pen/PENIntegracao.php'; echo VERSAO_MODULO_PEN;")

    if [ -f /var/lib/sei/dbcontrol/modulo-pen-instalado-${VERSAO_ENCONTRADA}.ok ]; then

        echo "Arquivo de controle do Modulo PEN encontrado, provavelmente ja foi instalado, pulando configuracao do modulo"

    else

        cd /opt
        echo -ne "$APP_DB_ROOT_USERNAME\n$APP_DB_ROOT_PASSWORD\n" | \
            php sip/scripts/mod-pen/sip_atualizar_versao_modulo_pen.php 2>&1 | \
            tee -a /var/lib/sei/dbcontrol/atualizacao-modulo-pen-${VERSAO_ENCONTRADA}.output

        erro=${PIPESTATUS[1]}
        if [ ! "$erro" == "0" ]; then
            echo "Erro ao executar script de atualizacao no sip. Abandonando..."
            exit 1
        fi


        echo -ne "$APP_DB_ROOT_USERNAME\n$APP_DB_ROOT_PASSWORD\n" | \
            php sei/scripts/mod-pen/sei_atualizar_versao_modulo_pen.php 2>&1 | \
            tee -a /var/lib/sei/dbcontrol/atualizacao-modulo-pen-${VERSAO_ENCONTRADA}.output

        erro=${PIPESTATUS[1]}
        if [ ! "$erro" == "0" ]; then
            echo "Erro ao executar script de atualizacao no sei. Abandonando..."
            exit 1
        fi

        echo "Iniciar Configuracao automatica do modulo"
        /automationscripts//mod-sei-pen.sh

        touch /var/lib/sei/dbcontrol/modulo-pen-instalado-${VERSAO_ENCONTRADA}.ok

    fi

{{- else }}

    echo "Variavel modulo_pen_instalar nao setada para true, pulando configuracao..."

{{- end }}

touch /var/lib/sei/dbcontrol/modulos-install.ok