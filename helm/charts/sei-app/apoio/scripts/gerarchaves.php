<?php

require_once '/opt/sip/web/Sip.php';

{{- with .Values.app.db.chave_acesso }}
$strChaveSipInformada = "{{ .sip }}";
$strCrcSipInformada = "{{ .sip_prefixo }}";
$strChaveSeiInformada = "{{ .sei }}";
$strCrcSeiInformada = "{{ .sei_prefixo }}";
{{- end }}

if ( strlen($strChaveSipInformada) != 64  || strlen($strChaveSeiInformada) != 64 ) {
  echo "Chaves de acesso devem conter 64 caracteres (Numeros ou letras minusculas).";
  exit(1);
}

$numIdSistemaSip = ScriptSip::obterIdSistema('SIP');
$numIdSistemaSei = ScriptSip::obterIdSistema('SEI');

$strCrc = $strCrcSipInformada;

$strSha256 = $strChaveSipInformada;

$objInfraBcrypt = new InfraBcrypt();
$strChave = $objInfraBcrypt->hash(md5($strSha256));

$objSistemaDTO_Chave = new SistemaDTO();
$objSistemaDTO_Chave->setStrCrc($strCrc);
$objSistemaDTO_Chave->setStrChaveAcesso($strChave);
$objSistemaDTO_Chave->setNumIdSistema($numIdSistemaSip);

$objSistemaBD = new SistemaBD(BancoSip::getInstance());
$objSistemaBD->alterar($objSistemaDTO_Chave);



$strCrc = $strCrcSeiInformada;
$strSha256 = $strChaveSeiInformada;

$objInfraBcrypt = new InfraBcrypt();
$strChave = $objInfraBcrypt->hash(md5($strSha256));

$objSistemaDTO_Chave = new SistemaDTO();
$objSistemaDTO_Chave->setStrCrc($strCrc);
$objSistemaDTO_Chave->setStrChaveAcesso($strChave);
$objSistemaDTO_Chave->setNumIdSistema($numIdSistemaSei);

$objSistemaBD = new SistemaBD(BancoSip::getInstance());
$objSistemaBD->alterar($objSistemaDTO_Chave);


?>