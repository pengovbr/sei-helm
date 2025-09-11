dir_charts=../charts

ifneq ($(shell helm version 2>/dev/null),)
else
$(error ************  Comando helm nao encontrado ou inexistente. Verifique... ************)
endif


help:   ## Lista de comandos disponiveis e descricao. Voce pode usar TAB para completar os comandos
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


lint: ## Valida determinado chart. Passe o parametro: chart=xxxx
	@if [ "$(chart)" = "" ]; then \
        echo "Informe o nome do chart, por ex: make chart=sei-app lint "; \
        exit 1; \
    fi;
	@echo "Rodando Lint no chart: $(chart)"; echo "";
	@helm lint $(dir_charts)/$(chart)
	@echo "======================================"; echo ""    


lint_all: ## Valida todos os charts
	@make chart=sei-solr lint
	@make chart=sei-memcached lint
	@make chart=sei-jod lint
	@make chart=sei-db lint
	@make chart=sei-app lint
	@make chart=chart-generico-dev lint


## todo testes de provisionamento no cluster