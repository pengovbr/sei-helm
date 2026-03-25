<?

/**
 * Arquivo de configura��o do M�dulo de Integra��o do SEI com o Processo Eletr�nico Nacional
 *
 * Seu desenvolvimento seguiu os mesmos padr�es de configura��o implementado pelo SEI e SIP e este
 * arquivo precisa ser adicionado � pasta de configura��es do SEI para seu correto carregamento pelo m�dulo.
 */

class ConfiguracaoModPEN extends InfraConfiguracao  {

  private static $instance = null;

    /**
     * Obt�m inst�ncia �nica (singleton) dos dados de configura��o do m�dulo de integra��o com Barramento PEN
     *
     *
     * @return ConfiguracaoModPEN
     */
  public static function getInstance()
    {
    if (ConfiguracaoModPEN::$instance == null) {
        ConfiguracaoModPEN::$instance = new ConfiguracaoModPEN();
    }
      return ConfiguracaoModPEN::$instance;
  }

    /**
     * Defini��o dos par�metros de configura��o do m�dulo
     *
     * @return array
     */
  public function getArrConfiguracoes()
    {
      return array(
          "PEN" => array(
              // Endere�o do Web Service principal de integra��o com o Barramento de Servi�os do PEN
              // Os endere�os dispon�veis s�o os seguintes (verifique se houve atualiza��es durante o procedimento de instala��o):
              //    - Homologa��o: https://homolog.api.processoeletronico.gov.br/interoperabilidade/rest/v3/
              //    - Produ��o: https://api.conectagov.processoeletronico.gov.br/interoperabilidade/rest/v3/
              "WebService" => "{{ .Values.app.modulo_pen_webservice }}",

              // Endere�o do Web Service de monitoramente de pend�ncias de tr�mite no Barramento de Servi�os do PEN
              // Configura��o necess�ria para que o envio e recebimento de processos sejam feitas de forma din�mica pelo sistema
              // Os endere�os dispon�veis s�o os seguintes (verifique se houve atualiza��es durante o procedimento de instala��o):
              //    - Homologa��o: https://homolog.pendencias.processoeletronico.gov.br/
              //    - Produ��o: https://pendencias.conectagov.processoeletronico.gov.br/
              "WebServicePendencias" => "",

              // Localiza��o completa do certificado digital utilizado para autentica��o nos servi�os do Barramento de Servi�os do PEN
              // e assinar os recibos de envio/conclus�o dos tr�mites de processo
              // Necess�rio que o arquivo de certificado esteja localizado dentro da pasta de configura��es do m�dulo:
              //  Ex: <DIRET�RIO RAIZ DE INSTALA��O DO SEI>/sei/config/mod-pen/certificado.pem
              "LocalizacaoCertificado" => "/opt/sei/config/mod-pen/certificado.pem",

              // Senha do certificado digital necess�rio para a aplica��o descriptografar a chave privada
              "SenhaCertificado" => "{{ .Values.app.modulo_pen_certificado_senha }}",

              // Quantidade de tentativas de requis��o dos servi�os do Barramento PEN antes que um erro possa ser lan�ado pela aplica��o
              // Necess�rio para aumentar a resili�ncia da integra��o em contextos de instabilidade de rede.
              // Valor padr�o: 3
              "NumeroTentativasErro" => 3,

              // Localiza��o do servidor Gearman de gerenciamento de fila de processamento de tarefas do Barramento PEN
              // As mensagem recebidas s�o organizadas em filas de tarefas e distribu�das entre os n�s da aplica��o para
              // processamento paralelo. Caso este par�metro n�o seja configurado ou o servidor este indispon�vel, o processamento ser�
              // feito diretamente pelo sistema na periodicidade definida pelo agendamento da tarefa PENAgendamento::receberProcessos
              "Gearman" => array(
                  "Servidor" => "",
                  "Porta" => "", //Padr�o: 4730
              ),

              // Configura��o padr�o do Envio Parcial
              "EnviarApenasComponentesDigitaisPendentes" => false
          )
      );
  }
}
