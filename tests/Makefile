SHELL := /bin/bash


ifeq ($(shell helm version 2>/dev/null),)
$(error ************  Comando helm nao encontrado ou inexistente. Verifique... ************)
endif

ifeq ($(shell kubectl version 2>/dev/null),)
$(error ************  Comando kubectl nao encontrado ou inexistente. Verifique... ************)
endif

ifeq ($(shell yq 2>/dev/null),)
$(error ************  Comando yq nao encontrado ou inexistente. Verifique... ************)
endif


include envtest.env

WARNING = "⚠️ --- "


help:   ## Lista de comandos disponiveis e descricao. Voce pode usar TAB para completar os comandos
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


print_warning: ## target de apoio para imprimir msg de warning
	@echo "$(WARNING)"
	@echo -e "$(msg)"
	@echo "$(WARNING)"
	@exit 1


validar_chart_pac: ## target de apoio para validar se informou o pacote
	@if [ "$(chart)" = "" ]; then \
        msg="Informe o nome do pacote chart, por ex: make chart=sei-app chart_name=sei1 targetmake"; \
        make msg="$$msg" print_warning; \
    fi;


validar_chart_name: ## target de apoio para validar se passou o nome do chart
	@if [ "$(chart_name)" = "" ]; then \
        msg="Informe o nome do chart, por ex: make chart=sei-app chart_name=sei1 targetmake"; \
        make msg="$$msg" print_warning; \
    fi;


validar_chart_namespace: ## target de apoio para validar se informou o namespace
	@if [ "$(chart_ns)" = "" ]; then \
        msg="Informe o namespace do chart, por ex: make chart=sei-app chart_ns=default targetmake"; \
        make msg="$$msg" print_warning; \
    fi;


validar_context: ## target de apoio. Verifica se foi passado contexto do kubernetes
	@set -e; if [ "$(kube_context)" = "" ]; then \
        msg="Informe o contexto kubernetes referente ao seu cluster kubernetes"; \
        make msg="$$msg" print_warning; \
    fi;
	@ip=$($(kube_context).ip-entrada) ; \
    if [ "$$ip" = "" ]; then make msg="Variavel $$(kubectl config current-context).ips-entrada nao definida em envtest.env" print_warning; fi;


validar_chart_params: validar_chart_pac validar_chart_name validar_chart_namespace validar_context ## target de apoio de validacao


chart_instalado: validar_chart_params ## verifica se o chart ja esta instalado
	@e=$$(helm -n $(chart_ns) ls -f $(chart_name) | wc -l | xargs); \
    if [ "$$e" = "2" ]; then \
        msg="Chart $(chart_name) ja instalado. Rode antes o comando make chart_ns=$(chart_ns) chart=$(chart) chart_name=$(chart_name) uninstall_chart"; \
        make msg="$$msg" print_warning; \
    fi;




lint: ## Valida determinado chart. Passe o parametro: chart=xxxx
	@if [ "$(chart)" = "" ]; then \
        make msg="Informe o nome do chart, por ex: make chart=sei-app lint " print_warning; \
    fi;
	@echo "Rodando Lint no chart: $(chart)"; echo "";
	@helm lint ../charts/$(chart)
	@echo "======================================"; echo ""


lint_all: ## Valida todos os charts
	@make chart=sei-solr lint
	@make chart=sei-memcached lint
	@make chart=sei-jod lint
	@make chart=sei-db lint
	@make chart=sei-app lint
	@make chart=chart-generico-dev lint



install_chart: validar_chart_params chart_instalado ## target para instalacao generica dos charts no kubernetes via helm
	@set -e; \
    kubectl config use-context $(kube_context); \
    rm -rf values-original.yaml values.yaml; \
    cp ../charts/$(chart)/values.yaml values-original.yaml; \
    yq -p properties -o yaml envtest.env | yq ".$(kube_context).$(chart_name)" > values.yaml; \
    if [ -f "sshelmvalues-test/$(kube_context).$(chart_name).yaml" ]; then \
        cp helmvalues-test/$(kube_context).$(chart_name).yaml values.yaml; \
    else \
        touch values.yaml; \
    fi; \
	helm -n $(chart_ns) install --create-namespace -f values-original.yaml -f values.yaml $(chart_name) ../charts/$(chart)
	@if [[ "$(chart)" = "chart-generico-dev" || "$(chart)" = "sei-app" ]]; then \
        h="$($(kube_context).$(chart_name).app.host)"; \
        if [ "$$h" = "" ]; then h="$($(kube_context).$(chart_name).sei-app.app.host)"; fi; \
        make -C Selenium loops_espera=$($(kube_context).loops_espera) host_url=$$h host_ip=$($(kube_context).ip-entrada) test_verificar_e_executar; \
    fi;


uninstall_chart: validar_chart_namespace validar_chart_name validar_context ## target para desinstalacao generica de charts
	@helm -n $(chart_ns) uninstall $(chart_name)


install_umbrella_chart: validar_context ## instala o chart sei-umbrella de acordo com os parametros do arquivo envtest.env
	@make chart_ns=$($(kube_context).tests-sei-umbrella.namespace) chart=chart-generico-dev chart_name=tests-sei-umbrella install_chart


uninstall_umbrella_chart: validar_context ## desinstala o chart sei-umbrella
	@make chart_ns=$($(kube_context).tests-sei-umbrella.namespace) chart=chart-generico-dev chart_name=tests-sei-umbrella uninstall_chart


install_sei1_e_2: validar_context ## instala todos os pacotes montando 2 instalacoes do SEI reaproveitando banco, solr e jod
	@make chart_ns=$($(kube_context).tests-sei-db.namespace) chart=sei-db chart_name=tests-sei-db install_chart
	@make chart_ns=$($(kube_context).tests-sei-jod.namespace) chart=sei-jod chart_name=tests-sei-jod install_chart
	@make chart_ns=$($(kube_context).tests-sei-solr.namespace) chart=sei-solr chart_name=tests-sei-solr install_chart
	@make chart_ns=$($(kube_context).tests-sei-memcached1.namespace) chart=sei-memcached chart_name=tests-sei-memcached1 install_chart
	@make chart_ns=$($(kube_context).tests-sei-app1.namespace) chart=sei-app chart_name=tests-sei-app1 install_chart
	@make chart_ns=$($(kube_context).tests-sei-memcached2.namespace) chart=sei-memcached chart_name=tests-sei-memcached2 install_chart
	@make chart_ns=$($(kube_context).tests-sei-app2.namespace) chart=sei-app chart_name=tests-sei-app2 install_chart


uninstall_sei1_e_2: validar_context ## desinstala o sei1 e sei2 via helm
	@make chart_ns=$($(kube_context).tests-sei-app1.namespace) chart_name=tests-sei-app1 uninstall_chart
	@make chart_ns=$($(kube_context).tests-sei-memcached1.namespace) chart_name=tests-sei-memcached1 uninstall_chart
	@make chart_ns=$($(kube_context).tests-sei-app2.namespace) chart_name=tests-sei-app2 uninstall_chart
	@make chart_ns=$($(kube_context).tests-sei-memcached2.namespace) chart_name=tests-sei-memcached2 uninstall_chart
	@make chart_ns=$($(kube_context).tests-sei-solr.namespace) chart=sei-solr chart_name=tests-sei-solr uninstall_chart
	@make chart_ns=$($(kube_context).tests-sei-jod.namespace) chart=sei-jod chart_name=tests-sei-jod uninstall_chart
	@make chart_ns=$($(kube_context).tests-sei-db.namespace) chart=sei-db chart_name=tests-sei-db uninstall_chart


test_all_contexts: ## roda todos os testes de provisionamento rotacionando os clusters kubernetes informados no arquivo envtest.env
	@set -e; for context in $(kube_contexts); do \
        echo "======================================================"; \
        echo "Alterando para o contexto: $${context}"; \
        kubectl config use-context $${context}; \
        make kube_context=$${context} install_umbrella_chart; \
        make kube_context=$${context} uninstall_umbrella_chart; \
        make kube_context=$${context} install_sei1_e_2; \
        make kube_context=$${context} uninstall_sei1_e_2; \
    done;
