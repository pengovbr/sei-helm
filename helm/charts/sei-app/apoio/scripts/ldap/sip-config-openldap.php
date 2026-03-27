<?php

require_once '/opt/sip/web/Sip.php';

$c = BancoSip::getInstance();
$c->abrirConexao();

$objServidorAutenticacaoDTO = new ServidorAutenticacaoDTO();
$objServidorAutenticacaoBD = new ServidorAutenticacaoBD(BancoSip::getInstance());

$objServidorAutenticacaoDTO = new ServidorAutenticacaoDTO();
$objServidorAutenticacaoDTO->setStrNome('{{ .Values.app.ldap.nome }}');
$qtd = $objServidorAutenticacaoBD->contar($objServidorAutenticacaoDTO);

if($qtd){
    echo "Servidor MeuOpenLdap ja cadastrado no SIP. Qualquer alteracao devera ser feita diretamente na tela do SIP\n";

}else{

    $objServidorAutenticacaoBD = new ServidorAutenticacaoBD(BancoSip::getInstance());
    $objServidorAutenticacaoDTO = new ServidorAutenticacaoDTO();
    $objServidorAutenticacaoDTO->setNumIdServidorAutenticacao(null);
    $objServidorAutenticacaoDTO->setStrNome("{{ .Values.app.ldap.nome }}");
    $objServidorAutenticacaoDTO->setStrStaTipo('{{ .Values.app.ldap.tipo }}');
    $objServidorAutenticacaoDTO->setStrEndereco('{{ .Values.app.ldap.endereco }}');
    $objServidorAutenticacaoDTO->setNumPorta({{ .Values.app.ldap.porta }});
    $objServidorAutenticacaoDTO->setStrSufixo('{{ .Values.app.ldap.sufixo }}');
    $objServidorAutenticacaoDTO->setStrUsuarioPesquisa('{{ .Values.app.ldap.usuarioPesquisa }}');
    $objServidorAutenticacaoDTO->setStrSenhaPesquisa('{{ .Values.app.ldap.senhaPesquisa }}');
    $objServidorAutenticacaoDTO->setStrContextoPesquisa('{{ .Values.app.ldap.contextoPesquisa }}');
    $objServidorAutenticacaoDTO->setStrAtributoFiltroPesquisa('{{ .Values.app.ldap.filtroPesquisa }}');
    $objServidorAutenticacaoDTO->setStrAtributoRetornoPesquisa('{{ .Values.app.ldap.retornoPesquisa }}');
    $objServidorAutenticacaoDTO->setNumVersao({{ .Values.app.ldap.numeroVersao }});
    $ret = $objServidorAutenticacaoBD->cadastrar($objServidorAutenticacaoDTO);

    echo "Servidor {{ .Values.app.ldap.nome }} Cadastrado no SIP com sucesso!!!\n";

    echo "Vamos agora associar o servidor ao Orgao 0\n";

    echo "Apagar associacoes do orgao 0\n";

    $objRelOrgaoAutenticacaoDTO = new RelOrgaoAutenticacaoDTO();
    $objRelOrgaoAutenticacaoDTO->retNumIdOrgao();
    $objRelOrgaoAutenticacaoDTO->retNumIdServidorAutenticacao();
    $objRelOrgaoAutenticacaoDTO->setNumIdOrgao(0);

    $objRelOrgaoAutenticacaoRN = new RelOrgaoAutenticacaoRN();
    $r = $objRelOrgaoAutenticacaoRN->listar($objRelOrgaoAutenticacaoDTO);

    $objRelOrgaoAutenticacaoBD = new RelOrgaoAutenticacaoBD(BancoSip::getInstance());
    for($i=0;$i<count($r);$i++){
        $objRelOrgaoAutenticacaoBD->excluir($r[$i]);
    }

    echo "Cadastrar associcao\n";

    $objServidorAutenticacaoDTO = new ServidorAutenticacaoDTO();
    $objServidorAutenticacaoDTO->retNumIdServidorAutenticacao();
    $objServidorAutenticacaoDTO->setStrNome('{{ .Values.app.ldap.nome }}');

    $objServidorAutenticacaoBD = new ServidorAutenticacaoBD(BancoSip::getInstance());
    $ret = $objServidorAutenticacaoBD->consultar($objServidorAutenticacaoDTO);

    $objRelOrgaoAutenticacaoBD = new RelOrgaoAutenticacaoBD(BancoSip::getInstance());
    $objRelOrgaoAutenticacaoDTO = new RelOrgaoAutenticacaoDTO();
    $objRelOrgaoAutenticacaoDTO->setNumIdOrgao(0);
    $objRelOrgaoAutenticacaoDTO->setNumIdServidorAutenticacao($ret->getNumIdServidorAutenticacao());
    $objRelOrgaoAutenticacaoDTO->setNumSequencia(0);
    $ret = $objRelOrgaoAutenticacaoBD->cadastrar($objRelOrgaoAutenticacaoDTO);

    echo "Vamos agora ativar o Orgao Zero para autenticar\n";

    $objOrgaoDTO = new OrgaoDTO();
    $objOrgaoDTO->setNumIdOrgao(0);
    $objOrgaoDTO->setStrSinAutenticar('S');
    $objOrgaoBD = new OrgaoBD(BancoSip::getInstance());
    $objOrgaoBD->alterar($objOrgaoDTO);

}

?>