SHELL := /bin/bash

include ../envtest.env

WARNING = "⚠️ --- "
CURLCMD = curl -s -k -L --resolve "$(host_url):443:$(host_ip)" https://$(host_url)/sei
CURLCMD_SIP = curl -s -k -L --resolve "$(host_url):443:$(host_ip)" https://$(host_url)/sip
CURLCMD_301 = $(CURLCMD) | grep 301
CURLCMDSEI_LOGIN = $(CURLCMD) | grep txtUsuario
CURLCMDSIP_LOGIN = $(CURLCMD_SIP) | grep txtUsuario

CMDSELENIUMCHROME=docker run -d --rm --name seleniumchrome -p 4444:4444 --add-host $(host_url):$(host_ip) -v /dev/shm:/dev/shm selenium/standalone-chrome:4.0.0-rc-1-prerelease-20210618

CMDSELENIUMTEST=docker run --rm -it -v "$$PWD"/PythonExported:/t -w /t --link seleniumchrome linhares/pytestseleniumdocker:latest bash -c "pytest --disable-pytest-warnings -W ignore::DeprecationWarning -o junit_family=xunit2 --junitxml=/t/resultado.xml test_suiteBasics-executar.py"



help:   ## Lista de comandos disponiveis e descricao. Voce pode usar TAB para completar os comandos
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


print_warning: ## target de apoio para imprimir msg de warning
	@echo "$(WARNING)"
	@echo -e "$(msg)"
	@echo "$(WARNING)"
	@exit 1


test_verificar_app_url: ## target de apoio verifica se a url do sei responde a pagina de login

	@echo "Vamos verificar se o SEI responde a pagina inicial"
	@echo "*****************************************************"
	@echo "*****************************************************"

	@echo "Tentando acessar o login do SEI"
	@echo "*****************************************************"
	@echo "*****************************************************";

	@for i in {1..15}; do \
		echo 'Tentando acessar...'; \
		var=$$(echo $$($(CURLCMDSEI_LOGIN))); \
		if [ "$$var" != "" ]; then \
			echo 'Pagina respondeu com tela de login'; \
			break; \
		else \
			echo 'Aguardando resposta ...'; \
		fi; \
		sleep 10; \
	done
	@var=$$(echo $$($(CURLCMDSEI_LOGIN)));  if [ "$$var" = "" ]; then make msg='Nao respondeu tela de login. Saindo do teste' print_warning; fi;

	@echo "Tentando acessar o login do SIP"
	@echo "*****************************************************"
	@echo "*****************************************************"
	@for i in {1..15}; do echo 'Tentando acessar...'; var=$$(echo $$($(CURLCMDSIP_LOGIN))); if [ "$$var" != "" ]; then echo 'Pagina respondeu com tela de login'; break; else echo 'Aguardando resposta ...'; fi; sleep 10; done
	@var=$$(echo $$($(CURLCMDSIP_LOGIN)));  if [ "$$var" = "" ]; then make msg='Nao respondeu tela de login. Saindo do teste' print_warning; fi;

	@echo "SEI respondeu a pagina inicial"
	@echo "*****************************************************"
	@echo "*****************************************************"


test_selenium_basico1: ## target de apoio roda um teste em selenium apontando para a instancia escolhida para criar processo com anexos

	@echo "*****************************************************"
	@echo "*****************************************************"
	@echo "Vamos agora rodar um teste simples no Selenium para saber se estao de acordo:"
	@echo "- login;"
	@echo "- modulos basicos instalados;"
	@echo "- criacao de processo com anexo e doc interno;"
	@echo "- logout"
	@echo "*****************************************************"
	@echo "*****************************************************"

	@echo "Subindo SeleniumChrome..."

	@var=$$(echo $$(docker ps -a | grep "seleniumchrome"));  if [ "$$var" != "" ]; then docker stop seleniumchrome; fi;
	$(CMDSELENIUMCHROME)

	@for i in {1..4}; do echo 'Tentando acessar SeleniumChrome...'; var=$$(echo $$(docker logs  seleniumchrome | grep "Started Selenium Standalone")); if [ "$$var" != "" ]; then echo 'SeleniumChrome respondeu com sucesso....'; break; else echo 'Aguardando SeleniumChrome...'; fi; sleep 5;  done; \
	var=$$(echo $$(docker logs  seleniumchrome | grep "Started Selenium Standalone"));  if [ "$$var" = "" ]; then make msg='Selenium nao subiu. Saindo do teste' print_warning;  fi;

	@echo "Selenium no ar vamos rodar o teste...";
	@rm -f PythonExported/test_suiteBasics-executar.py && cp PythonExported/test_suiteBasics.py PythonExported/test_suiteBasics-executar.py
	@sed -i'' -e "s|<<PROTOCOLO>>|https|" PythonExported/test_suiteBasics-executar.py
	@sed -i'' -e "s|<<HOST>>|$(host_url)|" PythonExported/test_suiteBasics-executar.py
	@sed -i'' -e "s|<<SENHA>>|teste|" PythonExported/test_suiteBasics-executar.py

	$(CMDSELENIUMTEST) || true

	@echo ""; \
	var=$$(grep "failure message" PythonExported/resultado.xml); \
	if [ "$$var" != "" ]; then echo 'Deu erro no teste Selenium'; fi;
	
	@echo ""
	@echo "Testes finalizados"
	@echo "Obrigado SeleniumChrome, mas vou te destruir..."
	@docker stop seleniumchrome


	@echo ""; \
	var=$$(grep "failure message" PythonExported/resultado.xml); \
	if [ "$$var" != "" ]; then make msg='Deu erro no teste Selenium, verifique. Parando o restante dos testes...' print_warning; fi;

	@echo ""; \
	var=$$(grep "test setup failure" PythonExported/resultado.xml); \
	if [ "$$var" != "" ]; then make msg='Deu erro no teste Selenium, verifique. Parando o restante dos testes...' print_warning; fi;



test_verificar_e_executar: test_verificar_app_url
	make test_selenium_basico1