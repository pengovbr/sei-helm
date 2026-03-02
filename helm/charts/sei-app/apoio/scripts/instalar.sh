#!/bin/sh

set -e

if [ -z "$APP_PROTOCOLO" ] || \
   [ -z "$APP_HOST" ] || \
   [ -z "$APP_ORGAO" ] || \
   [ -z "$APP_ORGAO_DESCRICAO" ] || \
   [ -z "$APP_NOMECOMPLEMENTO" ] || \
   [ -z "$APP_DB_TIPO" ] || \
   [ -z "$APP_DB_PORTA" ] || \
   [ -z "$APP_DB_SEI_BASE" ] || \
   [ -z "$APP_DB_SIP_BASE" ] || \
   [ -z "$APP_DB_SIP_USERNAME" ] || \
   [ -z "$APP_DB_SIP_PASSWORD" ] || \
   [ -z "$APP_DB_SEI_USERNAME" ] || \
   [ -z "$APP_DB_SEI_PASSWORD" ] || \
   [ -z "$APP_DB_ROOT_USERNAME" ] || \
   [ -z "$APP_DB_ROOT_PASSWORD" ]; then
    echo "Informe as seguinte variáveis de ambiente no seu docker-compose ou no container:"
    echo "APP_PROTOCOLO=$APP_PROTOCOLO"
    echo "APP_HOST=$APP_HOST"
    echo "APP_ORGAO=$APP_ORGAO"
    echo "APP_ORGAO_DESCRICAO=$APP_ORGAO_DESCRICAO"
    echo "APP_NOMECOMPLEMENTO=$APP_NOMECOMPLEMENTO"
    echo "APP_DB_TIPO=$APP_DB_TIPO"
    echo "APP_DB_PORTA=$APP_DB_PORTA"
    echo "APP_DB_SIP_BASE=$APP_DB_SIP_BASE"
    echo "APP_DB_SEI_BASE=$APP_DB_SEI_BASE"
    echo "APP_DB_SIP_USERNAME=$APP_DB_SIP_USERNAME"
    echo "APP_DB_SIP_PASSWORD=$APP_DB_SIP_PASSWORD"
    echo "APP_DB_SEI_USERNAME=$APP_DB_SEI_USERNAME"
    echo "APP_DB_SEI_PASSWORD=$APP_DB_SEI_PASSWORD"
    echo "APP_DB_ROOT_USERNAME=$APP_DB_ROOT_USERNAME"
    echo "APP_DB_ROOT_PASSWORD=$APP_DB_ROOT_PASSWORD"

    exit 1
fi

mkdir -p /var/lib/sei/dbcontrol
mkdir -p /var/lib/sei/dbfiles
mkdir -p /var/lib/sei/tmpfiles

chown www-data /var/lib/sei/dbfiles
chown www-data /var/lib/sei/tmpfiles

while [ ! -f /var/lib/sei/dbcontrol/bancoinstalado.ok ]; do
    echo 'Aguardando Job dbcreate Finalizar...'
    sleep 2
done

APP_HOST_URL=$APP_PROTOCOLO://$APP_HOST

# vefificar se existe codigo fonte
if [ ! -f /opt/sei/web/SEI.php ] || [ ! -f /opt/sip/web/Sip.php ] ; then
  echo "Codigo fonte do sei  ou sip nao encontrado ou sem permissao. Abandonando subida..."
  exit 1
fi

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

echo "***************************************************"
echo "***************************************************"
echo "UPDATE NA BASE DE DADOS - ORGAO E SISTEMA**********"
echo "***************************************************"
echo "***************************************************"


if [ ! -f /var/lib/sei/dbcontrol/sistema.ok ]; then
    # Atualização do endereço de host da aplicação
    echo "Atualizando Banco de Dados com as informacoes de sistema..."

    date '+%Y-%m-%d %H:%M:%S' >> /var/lib/sei/dbcontrol/sistema.output
    php -r "
    require_once '/opt/sip/web/Sip.php';
    \$conexao = BancoSip::getInstance();
    \$conexao->abrirConexao();
    \$conexao->executarSql(\"update sistema set pagina_inicial='$APP_HOST_URL/sip' where sigla='SIP'\");
    \$conexao->executarSql(\"update sistema set pagina_inicial='$APP_HOST_URL/sei/inicializar.php', web_service='http://app/sei/controlador_ws.php?servico=sip' where sigla='SEI'\");
    " 2>&1 | tee -a /var/lib/sei/dbcontrol/sistema.output

    touch /var/lib/sei/dbcontrol/sistema.ok
else
    echo "Atualizacao de sistema ja feita anteriormente, pulando para a proxima etapa"
fi

if [ ! -f /var/lib/sei/dbcontrol/orgao.ok ]; then
    # Atualização do endereço de host da aplicação
    echo "Atualizando Banco de Dados com as informacoes de orgao..."

    date '+%Y-%m-%d %H:%M:%S' >> /var/lib/sei/dbcontrol/orgao.output
    php -r "
    require_once '/opt/sip/web/Sip.php';
    \$conexao = BancoSip::getInstance();
    \$conexao->abrirConexao();
    \$conexao->executarSql(\"update orgao set sigla='$APP_ORGAO', descricao='$APP_ORGAO_DESCRICAO' where id_orgao=0\");
    " 2>&1 | tee -a /var/lib/sei/dbcontrol/orgao.output

    php -r "
    require_once '/opt/sei/web/SEI.php';
    \$conexao = BancoSEI::getInstance();
    \$conexao->abrirConexao();
    \$conexao->executarSql(\"update orgao set sigla='$APP_ORGAO', descricao='$APP_ORGAO_DESCRICAO' where id_orgao=0\");
    " 2>&1 | tee -a /var/lib/sei/dbcontrol/orgao.output

    touch /var/lib/sei/dbcontrol/orgao.ok
else
    echo "Atualizacao de orgao ja feita anteriormente, pulando para a proxima etapa"
fi

echo "***************************************************"
echo "***************************************************"
echo "**RODAR ARQUIVOS DE ATUALIZACAO DO SIP e SEI*******"
echo "***************************************************"
echo "***************************************************"

VERSAO_ENCONTRADA=$(php -r "require_once '/opt/sip/web/Sip.php'; echo SIP_VERSAO;")
if [ -f /var/lib/sei/dbcontrol/atualizacao-sip-${VERSAO_ENCONTRADA}.ok ]; then
    echo "Arquivos da atualização para o SIP já rodaram nessa versao: ${VERSAO_ENCONTRADA}. Pulando para a proxima etapa"
else

    date '+%Y-%m-%d %H:%M:%S' >> /var/lib/sei/dbcontrol/atualizacao-sip-${VERSAO_ENCONTRADA}.output

    set +e
    echo -ne "$APP_DB_ROOT_USERNAME\n$APP_DB_ROOT_PASSWORD\n" | \
        php /opt/sip/scripts/atualizar_versao_sip.php > /tmp/result.txt
    erro=$?
    set -e

    cat /tmp/result.txt | tee -a /var/lib/sei/dbcontrol/atualizacao-sip-${VERSAO_ENCONTRADA}.output
    if [ ! "$erro" == "0" ]; then
        set +e
        result=$(cat /tmp/result.txt | grep -E "(JA ESTA INSTALADA|NAO CORRESPONDE COM A ULTIMA VERSAO)")
        set -e
        if [ "$result" == "" ]; then
          set -e
          echo "Erro ao atualizar o SIP. Abandonando a execucao..."
          exit 1
        fi
    fi
    touch /var/lib/sei/dbcontrol/atualizacao-sip-${VERSAO_ENCONTRADA}.ok

fi

VERSAO_ENCONTRADA=$(php -r "require_once '/opt/sei/web/SEI.php'; echo SEI_VERSAO;")
if [ -f /var/lib/sei/dbcontrol/atualizacao-sei-${VERSAO_ENCONTRADA}.ok ]; then
    echo "Arquivos da atualização para o SEI já rodaram nessa versao: ${VERSAO_ENCONTRADA}. Pulando para a proxima etapa"
else

    date '+%Y-%m-%d %H:%M:%S' >> /var/lib/sei/dbcontrol/atualizacao-sei-${VERSAO_ENCONTRADA}.output

    set +e
    echo -ne "$APP_DB_ROOT_USERNAME\n$APP_DB_ROOT_PASSWORD\n" | \
        php /opt/sei/scripts/atualizar_versao_sei.php > /tmp/result.txt
    erro=$?
    set -e

    cat /tmp/result.txt | tee -a /var/lib/sei/dbcontrol/atualizacao-sei-${VERSAO_ENCONTRADA}.output
    if [ ! "$erro" == "0" ]; then
        set +e
        result=$(cat /tmp/result.txt | grep -E "(JA ESTA INSTALADA|NAO CORRESPONDE COM A ULTIMA VERSAO)")
        set -e
        if [ "$result" == "" ]; then
          set -e
          echo "Erro ao atualizar o SIP. Abandonando a execucao..."
          exit 1
        fi
    fi
    touch /var/lib/sei/dbcontrol/atualizacao-sei-${VERSAO_ENCONTRADA}.ok
fi

echo "***************************************************"
echo "***************************************************"
echo "**RODAR ARQUIVOS DE ATUALIZACAO DE RECURSO*********"
echo "***************************************************"
echo "***************************************************"

VERSAO_ENCONTRADA=$(php -r "require_once '/opt/sip/web/Sip.php'; echo SIP_VERSAO;")
if [ -f /sei/controlador-instalacoes/atualizacao-sip-${VERSAO_ENCONTRADA}-recurso.ok ]; then
    echo "Arquivos da atualização de recurso para o SIP já rodaram nessa versao: ${VERSAO_ENCONTRADA}. Pulando para a proxima etapa"
else

    date '+%Y-%m-%d %H:%M:%S' >> /var/lib/sei/dbcontrol/atualizacao-sip-${VERSAO_ENCONTRADA}-recurso.output

    set +e
    echo -ne "$APP_DB_ROOT_USERNAME\n$APP_DB_ROOT_PASSWORD\n" | \
        php /opt/sip/scripts/atualizar_recursos_sei.php > /tmp/result.txt
    erro=$?
    set -e

    cat /tmp/result.txt | tee -a /var/lib/sei/dbcontrol/atualizacao-sip-${VERSAO_ENCONTRADA}-recurso.output
    if [ ! "$erro" == "0" ]; then
        set +e
        result=$(cat /tmp/result.txt | grep -E "(JA ESTA INSTALADA|NAO CORRESPONDE COM A ULTIMA VERSAO)")
        set -e
        if [ "$result" == "" ]; then
          set -e
          echo "Erro ao atualizar o SIP. Abandonando a execucao..."
          exit 1
        fi
    fi
    touch /var/lib/sei/dbcontrol/atualizacao-sip-${VERSAO_ENCONTRADA}-recurso.ok
fi

touch /var/lib/sei/dbcontrol/install-initial.ok