<?php

require_once '/opt/sip/web/Sip.php';

$c = BancoSip::getInstance();
$c->abrirConexao();

$objServidorAutenticacaoDTO = new ServidorAutenticacaoDTO();
$objServidorAutenticacaoBD = new ServidorAutenticacaoBD(BancoSip::getInstance());

$objServidorAutenticacaoDTO = new ServidorAutenticacaoDTO();
$objServidorAutenticacaoDTO->setStrNome('{{ .Values.app.install.ldap.nome }}');
$qtd = $objServidorAutenticacaoBD->contar($objServidorAutenticacaoDTO);

if($qtd){
    echo "Servidor MeuOpenLdap ja cadastrado no SIP. Qualquer alteracao devera ser feita diretamente na tela do SIP\n";

}else{

    $objServidorAutenticacaoBD = new ServidorAutenticacaoBD(BancoSip::getInstance());
    $objServidorAutenticacaoDTO = new ServidorAutenticacaoDTO();
    $objServidorAutenticacaoDTO->setNumIdServidorAutenticacao(null);
    $objServidorAutenticacaoDTO->setStrNome("{{ .Values.app.install.ldap.nome }}");
    $objServidorAutenticacaoDTO->setStrStaTipo('{{ .Values.app.install.ldap.tipo }}');
    $objServidorAutenticacaoDTO->setStrEndereco('{{ .Values.app.install.ldap.endereco }}');
    $objServidorAutenticacaoDTO->setNumPorta({{ .Values.app.install.ldap.porta }});
    $objServidorAutenticacaoDTO->setStrSufixo('{{ .Values.app.install.ldap.sufixo }}');
    $objServidorAutenticacaoDTO->setStrUsuarioPesquisa('{{ .Values.app.install.ldap.usuarioPesquisa }}');
    $objServidorAutenticacaoDTO->setStrSenhaPesquisa('{{ .Values.app.install.ldap.senhaPesquisa }}');
    $objServidorAutenticacaoDTO->setStrContextoPesquisa('{{ .Values.app.install.ldap.contextoPesquisa }}');
    $objServidorAutenticacaoDTO->setStrAtributoFiltroPesquisa('{{ .Values.app.install.ldap.filtroPesquisa }}');
    $objServidorAutenticacaoDTO->setStrAtributoRetornoPesquisa('{{ .Values.app.install.ldap.retornoPesquisa }}');
    $objServidorAutenticacaoDTO->setNumVersao({{ .Values.app.install.ldap.numeroVersao }});
    $ret = $objServidorAutenticacaoBD->cadastrar($objServidorAutenticacaoDTO);

    echo "Servidor {{ .Values.app.install.ldap.nome }} Cadastrado no SIP com sucesso!!!\n";

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
    $objServidorAutenticacaoDTO->setStrNome('{{ .Values.app.install.ldap.nome }}');

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