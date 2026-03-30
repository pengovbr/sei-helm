#!/bin/bash

set -e

GERAR_CHAVES="{{ ternary "false" "true" (empty .Values.app.db.chave_acesso.sei) }}"

while [ ! -f /var/lib/sei/dbcontrol/bancoinstalado.ok ]; do
    echo 'Aguardando Job dbcreate Finalizar...'
    sleep 2
done

if [ ! "${GERAR_CHAVES}" = "true" ]; then
    echo "Chaves sip e sei nao informadas. Nao vamos gerar chaves."
    echo "Vamos usar as chaves informadas nos campos sei_custom e sip_custom"

    if [ "{{ .Values.app.db.chave_acesso.sei_custom }}" = "" ]; then
        echo "Chave de acesso do SEI nao informada. Verifique o valor do campo sei_custom"
        exit 1
    fi

    if [ "{{ .Values.app.db.chave_acesso.sip_custom }}" = "" ]; then
        echo "Chave de acesso do SIP nao informada. Verifique o valor do campo sip_custom"
        exit 1
    fi

    touch /var/lib/sei/dbcontrol/gerarChaves.ok
    exit 0
fi

php /automationscripts/gerarchaves.php

echo "Chaves geradas"

touch /var/lib/sei/dbcontrol/gerarChaves.ok