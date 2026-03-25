<?

class ConfiguracaoSip extends InfraConfiguracao
{

  private static $instance = null;

  public static function getInstance(): ConfiguracaoSip
  {
    if (ConfiguracaoSip::$instance == null) {
      ConfiguracaoSip::$instance = new ConfiguracaoSip();
    }
    return ConfiguracaoSip::$instance;
  }

  public function getArrConfiguracoes(): array
  {
    return array(
      'Sip' => array(
        'URL' => 'http://{{ .Values.app.host }}/sip',
        'Producao' => true
      ),

      'PaginaSip' => array('NomeSistema' => 'SIP'),

      'SessaoSip' => array(
        'SiglaOrgaoSistema' => '{{ .Values.app.orgao }}',
        'SiglaSistema' => 'SIP',
        'PaginaLogin' => 'http://{{ .Values.app.host }}/sip/login.php',
        'SipWsdl' => 'http://web/sip/controlador_ws.php?servico=sip',
        'ChaveAcesso' => '{{ .Values.app.sip_chave_acesso }}',
        'https' => false),

      'BancoSip'  => array(
          'Servidor' => '{{ .Values.app.db_host }}',
          'Porta' => '{{ .Values.app.db_porta }}',
          'Banco' => '{{ printf "%ssip" .Values.app.install.idInstalacao | lower }}',
          'Usuario' => '{{ printf "%susip" .Values.app.install.idInstalacao | lower }}',
          'Senha' => '{{ printf "%susip" .Values.app.install.idInstalacao | lower }}',
          'UsuarioScript' => '{{ .Values.app.db_root_username }}',
          'SenhaScript' => '{{ .Values.app.db_root_password }}',
          'Tipo' => '{{ .Values.app.db_tipo }}'), //MySql, SqlServer, Oracle ou PostgreSql

      /*
      'BancoAuditoriaSip'  => array(
          'Servidor' => '[Servidor BD]',
          'Porta' => '',
          'Banco' => '',
          'Usuario' => '',
          'Senha' => '',
          'Tipo' => ''), //MySql, SqlServer, Oracle ou PostgreSql
      */

	'CacheSip' => array('Servidor' => '{{ .Values.app.memcached_host }}',
			                'Porta' => '11211'),

      'hCaptcha' => array(
        'ChaveSecreta' => '',
        'ChaveSite' => ''
      ),

      'ReCaptchaV2' => array(
        'ChaveSecreta' => '',
        'ChaveSite' => ''
      ),

      'ReCaptchaV3' => array(
        'ChaveSecreta' => '',
        'ChaveSite' => '',
        'Score' => 0.5
      ),

		'InfraMail' => array(
				'Tipo' => '{{ .Values.app.mail_tipo }}', //1 = sendmail (neste caso nao e necessario configurar os atributos abaixo), 2 = SMTP
				'Servidor' => '{{ .Values.app.mail_servidor }}',
				'Porta' => '{{ .Values.app.mail_porta }}',
				'Codificacao' => '{{ .Values.app.mail_codificacao }}', //8bit, 7bit, binary, base64, quoted-printable
				'MaxDestinatarios' => '{{ .Values.app.mail_maxdestinatarios }}', //numero maximo de destinatarios por mensagem
				'MaxTamAnexosMb' => '{{ .Values.app.mail_max_tamanho_anexos }}', //tamanho maximo dos anexos em Mb por mensagem
				'Seguranca' => '{{ .Values.app.mail_seguranca }}', //TLS, SSL ou vazio
				'Autenticar' => '{{ .Values.app.mail_autenticar }}', //se true entao informar Usuario e Senha
				'Usuario' => '{{ .Values.app.mail_usuario }}',
				'Senha' => '{{ .Values.app.mail_senha }}',
				'Protegido' => '{{ .Values.app.mail_protegido }}' //campo usado em desenvolvimento, se tiver um email preenchido entao todos os emails enviados terao o destinatario ignorado e substituido por este valor (evita envio incorreto de email)
		    )
        );
  }
}

?>