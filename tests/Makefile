SHELL := /bin/bash



ifeq ($(shell helm version 2>/dev/null),)
$(error ************  Comando helm nao encontrado ou inexistente. Verifique... ************)
endif
ifeq ($(shell kubectl version 2>/dev/null),)
$(error ************  Comando kubectl nao encontrado ou inexistente. Verifique... ************)
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

verify_kubectl:
ifeq ($(shell kubectls version 2>/dev/null),)
	$(error ************  Comando kubectl nao encontrado ou inexistente. Verifique... ************)
endif



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










validar_chart_pac:
	@if [ "$(chart)" = "" ]; then \
        msg="Informe o nome do pacote chart, por ex: make chart=sei-app chart_name=sei1 targetmake"; \
        make msg="$$msg" print_warning; \
    fi;

validar_chart_name:
	@if [ "$(chart_name)" = "" ]; then \
        msg="Informe o nome do chart, por ex: make chart=sei-app chart_name=sei1 targetmake"; \
        make msg="$$msg" print_warning; \
    fi;

validar_chart_namespace:
	@if [ "$(chart_ns)" = "" ]; then \
        msg="Informe o namespace do chart, por ex: make chart=sei-app chart_ns=default targetmake"; \
        make msg="$$msg" print_warning; \
    fi;

validar_chart_params: validar_chart_pac validar_chart_name validar_chart_namespace

verificar_chart_umbrella_values:
	@if [ ! -f "helmvalues-test/tests-sei-umbrella.yaml" ]; then \
    msg="Arquivo helmvalues-test/tests-sei-umbrella.yaml com os values do chart nao fornecido.\n"; \
    msg="$${msg}Ha um exemplo em helmvalues-test/tests-sei-umbrella.example.yaml.\n"; \
    msg="$${msg}Copie-o e renomei-o alterando seus valores de acordo com seu cluster"; \
    make msg="$$msg" print_warning; \
    exit 1; \
    fi;

verificar_chart_sei1_2_values:
	@if [ ! -f "helmvalues-test/tests-sei-app1.yaml" ]; then \
    msg="Arquivo helmvalues-test/tests-sei-app1.yaml com os values do chart nao fornecido.\n"; \
    msg="$${msg}Ha um exemplo em helmvalues-test/tests-sei-app1.example.yaml.\n"; \
    msg="$${msg}Copie-o e renomei-o alterando seus valores de acordo com seu cluster"; \
    make msg="$$msg" print_warning; \
    fi; \
	if [ ! -f "helmvalues-test/tests-sei-app2.yaml" ]; then \
    msg="Arquivo helmvalues-test/tests-sei-app2.yaml com os values do chart nao fornecido.\n"; \
    msg="$${msg}Ha um exemplo em helmvalues-test/tests-sei-app2.example.yaml.\n"; \
    msg="$${msg}Copie-o e renomei-o alterando seus valores de acordo com seu cluster"; \
    make msg="$$msg" print_warning; \
    fi;


vefificar_context: ## target de apoio. Verifica se foi passado contexto do kubernetes
	@set -e; if [ "$(kube_context)" = "" ]; then \
        msg="Informe o contexto kubernetes referente ao seu cluster kubernetes"; \
        make msg="$$msg" print_warning; \
    fi;
	@set +e; ip=$$(grep $$(kubectl config current-context)-ip-entrada envtest.env | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'); set -e; \
    if [ "$$ip" = "" ]; then make msg="Variavel $$(kubectl config current-context)-ips-entrada nao definida em envtest.env" print_warning; fi;




chart_instalado: validar_chart_params
	@e=$$(helm -n $(chart_ns) ls -f $(chart_name) | wc -l | xargs); \
    if [ "$$e" = "2" ]; then \
        msg="Chart $(chart_name) ja instalado. Rode antes o comando make chart_ns=$(chart_ns) chart=$(chart) chart_name=$(chart_name) uninstall_chart"; \
        make msg="$$msg" print_warning; \
    fi;


install_chart: validar_chart_params chart_instalado vefificar_context
	@set -e; rm -rf values-original.yaml values.yaml; \
    cp ../charts/$(chart)/values.yaml values-original.yaml; \
    if [ -f "helmvalues-test/$(chart_name).yaml" ]; then \
        cp helmvalues-test/$(chart_name).yaml values.yaml; \
    else \
        touch values.yaml; \
    fi; \
    sed -i -e "s|fontes_git_privkey:.*|fontes_git_privkey: $(fontes_git_privkey)|g" values-original.yaml;
	helm -n $(chart_ns) install --create-namespace -f values-original.yaml -f values.yaml $(chart_name) ../charts/$(chart)
	@set +e; ip=$$(grep $$(kubectl config current-context)-ip-entrada envtest.env | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'); set -e; \
    if [[ "$(chart)" = "chart-generico-dev" ]]; then \
        make -C Selenium host_url=$(umbrella_url) host_ip=$$ip test_verificar_e_executar; \
    fi; \
	if [[ "$(chart)" = "sei-app"  ]]; then \
        make -C Selenium host_url=$(app1.host.name) host_ip=$$ip test_verificar_e_executar; \
    fi;
    


uninstall_chart: validar_chart_namespace validar_chart_name
	helm -n $(chart_ns) uninstall $(chart_name)



install_umbrella_chart: verificar_chart_umbrella_values
	@make chart_ns=$(umbrella_namespace) chart=chart-generico-dev chart_name=tests-sei-umbrella install_chart


uninstall_umbrella_chart:
	make chart_ns=$(umbrella_namespace) chart=chart-generico-dev chart_name=tests-sei-umbrella uninstall_chart


install_sei1_e_2: verificar_chart_sei1_2_values
	@make chart_ns=$(app1.db.namespace) chart=sei-db chart_name=tests-sei-db install_chart
	@make chart_ns=$(app1.jod.namespace) chart=sei-jod chart_name=tests-sei-jod install_chart    
	@make chart_ns=$(app1.solr.namespace) chart=sei-solr chart_name=tests-sei-solr install_chart
	@make chart_ns=$(app1.memcached.namespace) chart=sei-memcached chart_name=tests-sei-memcached1 install_chart
	@make chart_ns=$(app1.app.namespace) chart=sei-app chart_name=tests-sei-app1 install_chart
	@make chart_ns=$(app2.memcached.namespace) chart=sei-memcached chart_name=tests-sei-memcached2 install_chart
	@make chart_ns=$(app2.app.namespace) chart=sei-app chart_name=tests-sei-app2 install_chart


uninstall_sei1_e_2:
	@make chart_ns=$(app1.app.namespace) chart_name=tests-sei-app1 uninstall_chart
	@make chart_ns=$(app1.memcached.namespace) chart_name=tests-sei-memcached1 uninstall_chart
	@make chart_ns=$(app2.app.namespace) chart_name=tests-sei-app2 uninstall_chart
	@make chart_ns=$(app2.memcached.namespace) chart_name=tests-sei-memcached2 uninstall_chart
	@make chart_ns=$(app1.solr.namespace) chart=sei-solr chart_name=tests-sei-solr uninstall_chart
	@make chart_ns=$(app1.jod.namespace) chart=sei-jod chart_name=tests-sei-jod uninstall_chart
	@make chart_ns=$(app1.db.namespace) chart=sei-db chart_name=tests-sei-db uninstall_chart


test_all_contexts:
	set -e; for context in $(kube_contexts); do \
        echo "======================================================"; \
        echo "Alterando para o contexto: $${context}"; \
        kubectl config use-context $${context}; \
        make install_umbrella_chart; \
        make uninstall_umbrella_chart; \
        make install_sei1_e_2; \
        make uninstall_sei1_e_2; \
    done;
    




zinstall_chart: validar_chart_params chart_instalado
	@set -e; rm -rf values-original.yaml values.yaml; \
    cp ../charts/$(chart)/values.yaml values-original.yaml; \
    if [ -f "helmvalues-test/$(chart_name).yaml" ]; then \
        cp helmvalues-test/$(chart_name).yaml values.yaml; \
    else \
        touch values.yaml; \
    fi; \
    sed -i -e "s|fontes_git_privkey:.*|fontes_git_privkey: $(fontes_git_privkey)|g" values-original.yaml; \
    echo "Jesus"	
	@set +e; ip=$$(grep $$(kubectl config current-context)-ip-entrada envtest.env | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'); set -e; \
    echo "asdf"; \
    if [ "$(chart)" = "chart-generico-dev" ]; then \
        make -C Selenium host_url=$(umbrella_url) host_ip=asdf testes; \
    fi; 
    





zzzzzzinstall_chart_localhost:
	cp ../charts/sei-app/values.yaml helmvalues-test/env.env
	sed -i -e "s|fontes_git_privkey:.*|fontes_git_privkey: $(fontes_git_privkey)|g" helmvalues-test/env.env
	helm install teste-db ../charts/sei-db
	helm install teste-solr ../charts/sei-solr
	helm install teste-jod ../charts/sei-jod
	helm install teste-memcached ../charts/sei-memcached
	helm install -f helmvalues-test/env.env teste-app ../charts/sei-app

zzzzzzuninstall_chart_localhost:
	helm uninstall teste-app
	helm uninstall teste-memcached
	helm uninstall teste-jod
	helm uninstall teste-solr
	helm uninstall teste-db

zzzzzzinstall_chart_umbrella:
	cp ../charts/chart-generico-dev/values.yaml helmvalues-test/env.env
	sed -i -e "s|fontes_git_privkey:.*|fontes_git_privkey: $(fontes_git_privkey)|g" helmvalues-test/env.env
	sed -i -e "s|host: localhost|host: $(umbrella_url)|g" helmvalues-test/env.env
	sed -i -e "s|dbcluster: \"\"|dbcluster: \"default\"|g" helmvalues-test/env.env
	sed -i -e "s|jodcluster: \"\"|jodcluster: \"default\"|g" helmvalues-test/env.env
	sed -i -e "s|solrcluster: \"\"|solrcluster: \"default\"|g" helmvalues-test/env.env
	sed -i -e "s|memcachedcluster: \"\"|memcachedcluster: \"default\"|g" helmvalues-test/env.env
	helm install -f helmvalues-test/env.env teste-sei-umbrella ../charts/chart-generico-dev
	make -C Selenium host_url=$(umbrella_url) host_ip=$(umbrella_host_ip) test_selenium_basico1


zzzzuninstall_chart_umbrella:
	helm uninstall teste-sei-umbrella
















zzzinstall_chart_localhost:
    

zzzauninstall_chart_all:
	make chart_name=tests-sei-db uninstall_chart
	make chart_name=tests-sei-solr uninstall_chart
	make chart_name=tests-sei-jod uninstall_chart
	make chart_name=tests-sei-memcached1 uninstall_chart
	make chart_name=tests-sei-memcached2 uninstall_chart
	make chart_name=tests-sei1 uninstall_chart
	make chart_name=tests-sei2 uninstall_chart


zzzainstall_chart_all:
	make chart=sei-db chart_name=tests-sei-db install_chart
	make chart=sei-solr chart_name=tests-sei-solr install_chart
	make chart=sei-jod chart_name=tests-sei-jod install_chart
	make chart=sei-memcached chart_name=tests-sei-memcached1 install_chart
	make chart=sei-memcached chart_name=tests-sei-memcached2 install_chart
	make chart=sei-app chart_name=tests-sei1 install_chart
	make chart=sei-app chart_name=tests-sei2 chart_extra_params="--set app.memcachedcluster=tests-sei-memcached2 --set app.host=sei2.teste --set app.idInstalacao=orgao2 --set app.orgao=orgao2 --set app.orgao_descricao=OrgaoHelm2" install_chart
    

teste:
	echo "a$(app1.dbcluster)"
	cp ../charts/sei-app/values.yaml helmvalues-test/env.env
	sed -i -e "s|dbcluster:.*|dbcluster: $(app1.dbcluster)|g" helmvalues-test/env.env
	sed -i -e "s|jodcluster:.*|jodcluster: $(app1.jodcluster)|g" helmvalues-test/env.env