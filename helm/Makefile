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
