<?

    class ConfiguracaoSEI extends InfraConfiguracao
    {

      private static $instance = null;

      public static function getInstance()
      {
        if (ConfiguracaoSEI::$instance==null) {
          ConfiguracaoSEI::$instance = new ConfiguracaoSEI();
        }
        return ConfiguracaoSEI::$instance;
      }

      public function getArrConfiguracoes()
      {
        return array(

            'SEI' => array(
                'URL' => 'https://{{ .Values.app.host }}/sei',
                'Producao' => true,
                'RepositorioArquivos' => '/var/lib/sei/dbfiles',
                'WebServices' => true,
                'Modulos' => array(
                  {{- if .Values.app.modulo_estatisticas_instalar }}
                  'MdEstatisticas' => 'mod-sei-estatisticas',
                  {{- end }}
                  {{- if .Values.app.modulo_pen_instalar }}
                  'PENIntegracao' => 'pen',
                  {{- end }}
                  {{- if .Values.app.modulo_assinatura_instalar }}
                  'AssinaturaEletronicaIntegracao' => 'assinatura-eletronica',
                  {{- end }}

                ),
            ),

            {{- if .Values.app.modulo_estatisticas_instalar }}
            'MdEstatisticas' => array(
              'url' => '{{ .Values.app.modulo_estatisticas_url }}',
              'sigla' => '{{ .Values.app.modulo_estatisticas_sigla }}',
              'chave' => '{{ .Values.app.modulo_estatisticas_chave }}'
            ),
            {{- end }}

            'PaginaSEI' => array(
                'NomeSistema' => 'SEI',
                'NomeSistemaComplemento' => '{{ .Values.app.nome_complemento }}',
                'LogoMenu' => '',
                'Login' => true,
                'Ouvidoria' => true,
                'PublicacaoInterna' => true,
                'UsuariosExternos' => true,
                'ValidacaoDocumentos' => true,
                'ConsultaProcessual' => true
            ),

            'SessaoSEI' => array(
                'SiglaOrgaoSistema' => '{{ .Values.app.orgao }}',
                'SiglaSistema' => 'SEI',
                'PaginaLogin' => 'http://{{ .Values.app.host }}/sip/login.php',
                'SipWsdl' => 'http://web/sip/controlador_ws.php?servico=sip',
              'ChaveAcesso' => '{{ .Values.app.sei_chave_acesso }}',
              'https' => false),

     	      'BancoSEI'  => array(
     	          'Servidor' => '{{ .Values.app.db_host }}',
     	          'Porta' => '{{ .Values.app.db_porta }}',
     	          'Banco' => '{{ printf "%ssei" .Values.app.install.idInstalacao | lower }}',
     	          'Usuario' => '{{ printf "%susei" .Values.app.install.idInstalacao | lower }}',
     	          'Senha' => '{{ printf "%susei" .Values.app.install.idInstalacao | lower }}',
     	          'UsuarioScript' => '{{ .Values.app.db_root_username }}',
     	          'SenhaScript' => '{{ .Values.app.db_root_password }}',
     	          'Tipo' => '{{ .Values.app.db_tipo }}' ), //MySql, SqlServer, Oracle ou PostgreSql

          /*
         'BancoAuditoriaSEI'  => array(
              'Servidor' => '[servidor BD]',
              'Porta' => '',
              'Banco' => '',
              'Usuario' => '',
              'Senha' => '',
              'Tipo' => ''), //MySql, SqlServer, Oracle ou PostgreSql
         */

          /*
         'BancoReplicaSEI'  => array(
              'Servidor' => '[servidor BD]',
              'Porta' => '',
              'Banco' => '',
              'Usuario' => '',
              'Senha' => '',
              'Tipo' => ''), //MySql, SqlServer, Oracle ou PostgreSql
         */

    	'CacheSEI' => array('Servidor' => '{{ .Values.app.memcached_host }}',
    			                	'Porta' => '11211'),

                                    'Federacao' => array(
                                      'Habilitado' => {{ if .Values.app.federacao_habilitar }} true {{ else }} false {{ end }}
                                     ),

            'Manutencao' => array(
                'Ativada' => false,
                'Usuarios' => array('siglaUsuario1/siglaOrgao1', 'siglaUsuario2/siglaOrgao2'),
                'Mensagem' => 'Sistema em Manutenção',
                'Detalhes' => 'Previsão de retorno até as <b>XXhs.</b>'
            ),

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

            'JODConverter' => array('Servidor' => 'http://jod:8080/conversion?format=pdf'),

            'Solr' => array(
                'Servidor' => '{{ .Values.app.solr_url }}',
                'Usuario' => 'sei',
                'Senha' => 'SolrSei123$',
                'CoreProtocolos' => '{{ .Values.app.install.idInstalacao | lower }}-sei-protocolos',
                'TempoCommitProtocolos' => '{{ .Values.app.solr_tempo_commit_protocolos }}',
                'CoreBasesConhecimento' => '{{ .Values.app.install.idInstalacao | lower }}-sei-bases-conhecimento',
                'CorePublicacoes' => '{{ .Values.app.install.idInstalacao | lower }}-sei-publicacoes',
                'TempoCommitPublicacoes' => '{{ .Values.app.solr_tempo_commit_publicacoes }}'
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
    					'Protegido' => '{{ .Values.app.mail_protegido }}' //campo usado em desenvolvimento, se tiver um email preenchido entao todos os emails enviados terao o destinatario ignorado e substituido por este valor evitando envio incorreto de email
            )
        );
      }
    }
    ?>