<?php

/**
 * Arquivo de configuração do Módulo de Integração do SEI com a plataforma de Assinatura Avançada do gov.br
 *
 * Seu desenvolvimento seguiu os mesmos padrÃµes de configuração implementado pelo SEI e SIP e este
 * arquivo precisa ser adicionado à pasta de configurações do SEI para seu correto carregamento pelo módulo.
 */

class ConfiguracaoModAssinaturaEletronica extends InfraConfiguracao
{
  private static $instance = null;

    /**
     * Obtém instância única (singleton) dos dados de configuração do módulo de integração com a Conta gov.br
     *
     * @return ConfiguracaoModAssinaturaEletronica
     */
  public static function getInstance()
    {
    if (ConfiguracaoModAssinaturaEletronica::$instance == null) {
        ConfiguracaoModAssinaturaEletronica::$instance = new ConfiguracaoModAssinaturaEletronica();
    }
      return ConfiguracaoModAssinaturaEletronica::$instance;
  }

    /**
     * Definição dos parâmetros de configuração do módulo
     *
     * @return array
     */
  public function getArrConfiguracoes()
    {
      return array(
          'AssinaturaAvancada' => array(
              'url_provider' => '{{ .Values.app.mod_assinatura.urlprovider }}',
              'client_id' => '{{ .Values.app.mod_assinatura.clientid }}',
              'secret' => '{{ .Values.app.mod_assinatura.secret }}',
          ),
          'ValidarAPI' => array(
            'url' => '{{ .Values.app.mod_assinatura.validar_api_url }}',
            'key' => '{{ .Values.app.mod_assinatura.validar_api_key }}',
          ),
          'Assinador' => array(
            'Token' => array(
                'url' => '{{ .Values.app.mod_assinatura.token_url }}',
                'sign_url' => '{{ .Values.app.mod_assinatura.token_url_assinar }}',
            ),
            'IntegraICP' => array(
                'url' => '{{ .Values.app.mod_assinatura.integra_icp_url }}',
                'clearings_url' => '{{ .Values.app.mod_assinatura.integra_icp_url_clearings }}',
                'sign_url' => '{{ .Values.app.mod_assinatura.integra_icp_url_assinar }}',
            ),
            'CloudPSC' => array(
              'url' => '{{ .Values.app.mod_assinatura.cloud_psc_url }}',
              'start_url' => '{{ .Values.app.mod_assinatura.cloud_psc_url_start }}',
              'sign_url' => '{{ .Values.app.mod_assinatura.cloud_psc_url_assinar }}',
              'options' =>  ['govbr', 'serpro'],
              // 'options' =>  ['safeweb', 'soluti', 'govbr', 'serpro'],
            ),
            'apikey' => '{{ .Values.app.mod_assinatura.api_key_ithy }}',
          )
      );
  }
}