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
                  {{- if .Values.app.mod_estatistica.instalar }}
                  'MdEstatisticas' => 'mod-sei-estatisticas',
                  {{- end }}
                  {{- if .Values.app.mod_pen.instalar }}
                  'PENIntegracao' => 'pen',
                  {{- end }}
                  {{- if .Values.app.mod_assinatura.instalar }}
                  'AssinaturaEletronicaIntegracao' => 'assinatura-eletronica',
                  {{- end }}
                  {{- if .Values.app.mod_resposta.instalar }}
                  'MdRespostaIntegracao' => 'mod-sei-resposta',
                  {{- end }}

                ),
            ),

            {{- if .Values.app.mod_estatistica.instalar }}
            'MdEstatisticas' => array(
              'url' => '{{ .Values.app.mod_estatistica.url }}',
              'sigla' => '{{ .Values.app.mod_estatistica.sigla }}',
              'chave' => '{{ .Values.app.mod_estatistica.chave }}'
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
                {{- with .Values.app.db.chave_acesso }}
                'ChaveAcesso' => '{{ or .sei_custom ( printf "%s%s" .sei_prefixo .sei ) }}',
                {{- end }}
                'https' => false),

     	      'BancoSEI'  => array(
     	          'Servidor' => '{{ .Values.app.db.db_host }}',
     	          'Porta' => '{{ .Values.app.db.db_porta }}',
     	          'Banco' => '{{ .Values.app.db.seiDbName }}',
     	          'Usuario' => '{{ .Values.app.db.seiUser }}',
     	          'Senha' => '{{ .Values.app.db.seiPassword }}',
     	          'Tipo' => '{{ .Values.app.db.db_tipo }}' ), //MySql, SqlServer, Oracle ou PostgreSql

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
                'Servidor' => '{{ .Values.app.solr.solr_url }}',
                'Usuario' => '{{ .Values.app.solr.username }}',
                'Senha' => '{{ .Values.app.solr.password }}',
                'CoreProtocolos' => '{{ .Values.app.solr.idxProtocolo }}',
                'TempoCommitProtocolos' => {{ .Values.app.solr.idxProtocoloTime }},
                'CoreBasesConhecimento' => '{{ .Values.app.solr.idxBaseConhecimento }}',
                'TempoCommitBasesConhecimento' => {{ .Values.app.solr.idxBaseConhecimentoTime }},
                'CorePublicacoes' => '{{ .Values.app.solr.idxPublicacoes }}',
                'TempoCommitPublicacoes' => {{ .Values.app.solr.idxPublicacoesTime }}
            ),

          'InfraMail' => array(
    					'Tipo' => '{{ .Values.app.mail.tipo }}', //1 = sendmail (neste caso nao e necessario configurar os atributos abaixo), 2 = SMTP
    					'Servidor' => '{{ .Values.app.mail.servidor }}',
    					'Porta' => '{{ .Values.app.mail.porta }}',
    					'Codificacao' => '{{ .Values.app.mail.codificacao }}', //8bit, 7bit, binary, base64, quoted-printable
    					'MaxDestinatarios' => '{{ .Values.app.mail.maxdestinatarios }}', //numero maximo de destinatarios por mensagem
    					'MaxTamAnexosMb' => '{{ .Values.app.mail.max_tamanho_anexos }}', //tamanho maximo dos anexos em Mb por mensagem
    					'Seguranca' => '{{ .Values.app.mail.seguranca }}', //TLS, SSL ou vazio
    					'Autenticar' => '{{ .Values.app.mail.autenticar }}', //se true entao informar Usuario e Senha
    					'Usuario' => '{{ .Values.app.mail.usuario }}',
    					'Senha' => '{{ .Values.app.mail.senha }}',
    					'Protegido' => '{{ .Values.app.mail.protegido }}' //campo usado em desenvolvimento, se tiver um email preenchido entao todos os emails enviados terao o destinatario ignorado e substituido por este valor evitando envio incorreto de email
            )
        );
      }
    }
    ?>