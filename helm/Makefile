# onde vai gerar os pacotes helm
# optamos por gerar em repositorio separado para economizar espaco neste repo
# no seu ambiente aponte para o local desejado
package_location=../sei-helm-repo/docs

# repositorio a ser indexado
repositorio=https://pengovbr.github.io/sei-helm-repo


ifneq ($(shell helm version 2>/dev/null),)
else
$(error ************  Comando helm nao encontrado ou inexistente. Verifique... ************)
endif


help:   ## Lista de comandos disponiveis e descricao. Voce pode usar TAB para completar os comandos
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


test: ## Aviso para o teste em outra pasta
	@echo "Rode os testes que estao na pasta tests."


package: ## Empacota determinado chart. Passe o parametro: chart=xxxx
	@if [ "$(chart)" = "" ]; then \
        echo "Informe o nome do chart, por ex: make chart=sei-app package "; \
        exit 1; \
    fi;
	@echo "Empacotando $(chart)"
	@sleep 2
	@if [ ! "$(ignore_version)" = "true" ]; then \
        v=$$(egrep "^version:.*" charts/$(chart)/Chart.yaml | sed "s|version:||g" | sed "s| ||g"); \
        n=$$(egrep "^name:.*" charts/$(chart)/Chart.yaml | sed "s|name:||g" | sed "s| ||g"); \
        echo "Versao do Chart: $$v Avaliando se ja existe pacote com essa versao"; \
        if [ -f "$(package_location)/$${n}-$${v}.tgz" ]; then \
            echo "Ja existe pacote $${n} com essa versao: $$v"; \
            echo "Caso deseje sobrescrever, use o mesmo comando make com o parametro: ignore_version=true"; \
            echo "Ex: make chart=sei-app ignore_version=true package"; \
            echo "Esta flag nao funciona com make package_all"; \
            echo "Abandonando execucao..."; echo ""; echo ""; \
            exit 1; \
        fi; \
    fi;
	helm package charts/$(chart) -d $(package_location)

package_all: ## Empacota todos os charts
	@if [ "$(ignore_version)" = "true" ]; then \
        echo "Por questao de seguranca ignore_version=true nao funciona no package_all."; \
        echo "Para sobrescrever execute a construcao de cada pacote independentemente. Ex make chart=sei-app ignore_version=true package."; \
        exit 1; \
    fi;
	make chart=sei-solr package
	make chart=sei-memcached package
	make chart=sei-jod package
	make chart=sei-db package
	make chart=sei-cacheassets package
	make chart=sei-app package
	make chart=chart-generico-dev package


index: ## indexa o seu repositorio com a nova versao
	helm repo index $(package_location) --url $(repositorio)