SHELL := /bin/bash

ifneq ("$(wildcard envcontainers.env)","")
include envcontainers.env
endif

BUILD_ARGS := $(shell apoio/scripts/get_build_args.sh)

WARNING = "⚠️ --- "



help: ## Mostra essa ajuda. Voce pode usar tab para completar os comandos
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//' | sed -e 's|^\ ||'


verificar-parametro-imagemtmp: ## target de apoio para verificar se o parametro make IMAGETMP foi passado
	@if [ "$(IMAGETMP)" == "" ]; then echo "Informe a variavel make: IMAGETMP"; exit 1; fi;


verificar-parametro-imagemtmp-versao: ## target de apoio para verificar se o parametro make IMAGETMP_VERSION foi passado
	@if [ "$(IMAGETMP_VERSION)" == "" ]; then echo "Informe a variavel make: IMAGETMP_VERSION"; exit 1; fi;


verificar-parametro-imagemtmp-path: ## target de apoio para verificar se o parametro make IMAGETMP_PATH foi passado
	@if [ "$(IMAGETMP_PATH)" == "" ]; then echo "Informe a variavel make: IMAGETMP_PATH"; exit 1; fi;

## verificar-conteiner-imagem-rodando: target de apoio para verificar se ha conteiner rodando com determinada imagem
verificar-conteiner-imagem-rodando: verificar-parametro-imagemtmp verificar-parametro-imagemtmp-versao
	@echo "Verificando se a imagem: $(IMAGETMP) esta rodando ou parada no pool"; \
	if test "$$(docker ps -a | grep $(IMAGETMP))"; then \
	    echo "$(WARNING);" \
		echo "Imagem $(IMAGETMP) está sendo usada ou ainda persiste no pool docker stopada."; \
		echo "Pare e remova antes o conteiner. Abandonando execucao..."; \
		echo ""; echo ""; \
		echo "$(WARNING)" \
	exit 1; \
	fi

verificar-docker-registry: ## target de apoio para verificar se a variavel DOCKER_REGISTRY E VERSION foram informadas
	@if [ -z "$(DOCKER_REGISTRY)" ]; then echo "Var DOCKER_REGISTRY nao definida"; make envcontainers.env; exit 1; fi


verificar-imagem-alpine: ## target de apoio
	@if [ -z "$$(docker images -q $(IMAGE_ALPINE):$(IMAGE_ALPINE_VERSION) )" ]; then \
		echo "$(WARNING)"; \
		echo "Imagem alpine: $(IMAGE_ALPINE):$(IMAGE_ALPINE_VERSION), nao encontrada."; \
		echo "Vamos tentar baixar a mesma do seu registry."; \
		echo "Caso nao exista lah, vc deverah rodar o make build-conteiner-alpine"; \
		docker pull $(IMAGE_ALPINE):$(IMAGE_ALPINE_VERSION); \
		echo ""; echo ""; \
		echo "$(WARNING)"; \
		sleep 5; \
	fi;

verificar-imagem-solr-base: ## target de apoio
	@if [ -z "$$(docker images -q $(IMAGE_SOLR_BASE):$(IMAGE_SOLR_BASE_VERSION) )" ]; then \
		echo "$(WARNING)"; \
		echo "Imagem solr-base: $(IMAGE_SOLR_BASE):$(IMAGE_SOLR_BASE_VERSION), nao encontrada."; \
		echo "Vamos tentar baixar a mesma do seu registry."; \
		echo "Caso nao exista lah, vc deverah rodar o make build-conteiner-solr-base"; \
		docker pull $(IMAGE_SOLR_BASE):$(IMAGE_SOLR_BASE_VERSION); \
		echo ""; echo ""; \
		echo "$(WARNING)"; \
		sleep 5; \
	fi;

verificar-imagem-memcached-base: ## target de apoio
	@if [ -z "$$(docker images -q $(IMAGE_MEMCACHED_BASE):$(IMAGE_MEMCACHED_BASE_VERSION) )" ]; then \
		echo "$(WARNING)"; \
		echo "Imagem memcached-base: $(IMAGE_MEMCACHED_BASE):$(IMAGE_MEMCACHED_BASE_VERSION), nao encontrada."; \
		echo "Vamos tentar baixar a mesma do seu registry."; \
		echo "Caso nao exista lah, vc deverah rodar o make build-conteiner-memcached-base"; \
		docker pull $(IMAGE_MEMCACHED_BASE):$(IMAGE_MEMCACHED_BASE_VERSION); \
		echo ""; echo ""; \
		echo "$(WARNING)"; \
		sleep 5; \
	fi;

verificar-imagem-alpine-params: ## target de apoio para verificar se a imagem alpine foi informada
	@if [ -z "$(IMAGE_ALPINE)" ]; then echo "Var IMAGE_ALPINE nao definida"; make envcontainers.env; fi
	@if [ -z "$(IMAGE_ALPINE_VERSION)" ]; then echo "Var IMAGE_ALPINE_VERSION nao definida"; exit 1; fi
	@if [ -z "$(ALPINE_ORIGINAL_VERSION)" ]; then echo "Var ALPINE_ORIGINAL_VERSION nao definida"; exit 1; fi

verificar-app-params: ## target de apoio para verificar se token git foi passado
	@if [ -z "$(GIT_SEI_PAT)" ]; then echo "Informe GIT_SEI_PAT"; exit 1; fi
	@if [ -z "$(GIT_SEI_URL)" ]; then echo "Informe GIT_SEI_URL"; exit 1; fi
	@if [ -z "$(GIT_SEI_VERSION)" ]; then echo "Informe GIT_SEI_VERSION"; exit 1; fi

verificar-fontes: ## verifica se os fontes originais estao posicionados
	@if [ ! -f "app/assets/fontes/sei/web/SEI.php" ]; then echo "Fonte do SEI nao encontrado"; exit 1; fi
	@if [ ! -f "app/assets/fontes/sip/web/Sip.php" ]; then echo "Fonte do SIP nao encontrado"; exit 1; fi
	@if [ ! -f "app/assets/fontes/infra/infra_php/InfraSip.php" ]; then echo "Fonte do Infra nao encontrado"; exit 1; fi

getenv: ## target de apoio para copiar o arquivo envcontainers.env baseado no modelo envcontaners.example.env
		@cp -f envcontainers.example.env envcontainers.env
		@echo "Arquivo envcontainers.env criado com valores default.";
		@echo "Abra o arquivo e faca as alteracoes para o seu ambiente.";

envcontainers.env: ## target de apoio para verificar se existe arquivo envcontaners.env
		@echo "Nao encontrado arquivo env para as operacoes de containeres."
		@echo "Ha um arquivo modelo (envcontainers.example.env) que vc pode usar para preencher com suas informacoes."
		@echo "Basta rodar make getenv"
		@echo "Em seguida, altere nesse arquivo as informacoes para o seu ambiente"
		exit 1

getexample: ## traz o arquivo de exemplo caso o titular n exista
	@if [ ! -f "$(arq_titular)" ]; then \
	    echo "Arquivo $(arq_titular) inexistente. Vamos usar o arquivo de exemplo $(arq_example)"; \
		cp $(arq_example) $(arq_titular); \
	fi;

fontesGet: ## baixa os fontes e modulos do GIT informado
	@docker run -it --rm \
	    -v "${PWD}"/app/assets/fontes:/fontes \
		-v "${PWD}"/apoio/phpmaketools/assets:/assets \
		--env-file envcontainers.env $(IMAGE_APOIO_PHP):$(IMAGE_APOIO_PHP_VERSION) \
		sh -c "/assets/scripts/down_sei.sh"

## fontesPrepare: prepara os fontes antes de subirem para os containeres de app
fontesPrepare: verificar-fontes
	@docker run -it --rm \
	    -v "${PWD}"/app/assets/fontes:/fontes \
		-v "${PWD}"/apoio/phpmaketools/assets:/assets \
		--env-file envcontainers.env $(IMAGE_APOIO_PHP):$(IMAGE_APOIO_PHP_VERSION) \
		sh -c "/assets/scripts/prepare.sh"


#*****************************************************
#*******BUILD CONTAINERS TARGETS**********************
#*****************************************************

## build-conteiner-generic: target generico para construir imagens passadas por parametro
build-conteiner-generic: verificar-docker-registry verificar-parametro-imagemtmp-path
	@make IMAGETMP=$(IMAGETMP) IMAGETMP_VERSION=$(IMAGETMP_VERSION) verificar-conteiner-imagem-rodando
	docker build $(DOCKER_CACHE_ARG) --progress=plain $(BUILD_ARGS) -t $(IMAGETMP):$(IMAGETMP_VERSION) $(IMAGETMP_PATH)

## build-conteiner-generic2: target generico para construir imagens passadas por parametro
build-conteiner-generic2: verificar-docker-registry verificar-parametro-imagemtmp-path
	@make IMAGETMP=$(IMAGETMP) IMAGETMP_VERSION=$(IMAGETMP_VERSION) verificar-conteiner-imagem-rodando
	docker build $(DOCKER_CACHE_ARG) --progress=plain $(BUILD_ARGS) -t $(IMAGETMP):$(IMAGETMP_VERSION) --target $(IMAGETMP_TARGET) $(IMAGETMP_PATH)

## construir imagem alpine. Necessario rodar apenas uma vez por registry
## Nao esqueca de fazer o make publish-container-alpine
build-conteiner-alpine:  verificar-imagem-alpine-params
	@make IMAGETMP=$(IMAGE_ALPINE) \
		IMAGETMP_VERSION=$(IMAGE_ALPINE_VERSION) \
		IMAGETMP_PATH=alpine \
		build-conteiner-generic

## construir imagem solr-base. Necessario rodar apenas uma vez por registry
## Nao esqueca de fazer o make publish-container-solr-base
build-conteiner-solr-base:
	@make IMAGETMP=$(IMAGE_SOLR_BASE) \
		IMAGETMP_VERSION=$(IMAGE_SOLR_BASE_VERSION) \
		IMAGETMP_PATH=solr-base \
		build-conteiner-generic

## construir imagem memcached-base. Necessario rodar apenas uma vez por registry
## Nao esqueca de fazer o make publish-container-memcached-base
build-conteiner-memcached-base:
	@make IMAGETMP=$(IMAGE_MEMCACHED_BASE) \
		IMAGETMP_VERSION=$(IMAGE_MEMCACHED_BASE_VERSION) \
		IMAGETMP_PATH=memcached-base \
		build-conteiner-generic

## construir imagem mariadb-base. Necessario rodar apenas uma vez por registry
## Nao esqueca de fazer o make publish-container-mariadb-base
build-conteiner-mariadb-base:
	@make IMAGETMP=$(IMAGE_MARIADB_BASE) \
		IMAGETMP_VERSION=$(IMAGE_MARIADB_BASE_VERSION) \
		IMAGETMP_PATH=mariadb-base \
		build-conteiner-generic

## build-conteiner-apache construir imagem apache
build-conteiner-apache: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_APACHE} \
	    IMAGETMP_VERSION=$(IMAGE_APACHE_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=apache \
		build-conteiner-generic2

## build-conteiner-phpmaketools construir imagem phpmaketools
build-conteiner-phpmaketools: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_APOIO_PHP} \
	    IMAGETMP_VERSION=$(IMAGE_APOIO_PHP_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=phpmaketools \
		build-conteiner-generic2

## build-conteiner-php construir imagem php
build-conteiner-php: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_PHP} \
	    IMAGETMP_VERSION=$(IMAGE_PHP_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=php \
		build-conteiner-generic2

## build-conteiner-php-cron construir imagem php-cron
build-conteiner-php-cron: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_PHP_CRON} \
	    IMAGETMP_VERSION=$(IMAGE_PHP_CRON_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=php-cron \
		build-conteiner-generic2

## build-conteiner-php-install construir imagem php-install
build-conteiner-php-install: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_PHP_INSTALL} \
	    IMAGETMP_VERSION=$(IMAGE_PHP_INSTALL_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=php-install \
		build-conteiner-generic2

## build-conteiner-apache-php construir imagem apache-php
build-conteiner-apache-php: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_APACHE_PHP} \
	    IMAGETMP_VERSION=$(IMAGE_APACHE_PHP_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=apachephp \
		build-conteiner-generic2

## build-conteiner-memcached construir imagem memcached
build-conteiner-memcached: verificar-imagem-memcached-base
	@make IMAGETMP=${IMAGE_MEMCACHED} \
	    IMAGETMP_VERSION=$(IMAGE_MEMCACHED_VERSION) \
		IMAGETMP_PATH=memcached \
		build-conteiner-generic

## build-conteiner-jod construir imagem jod
build-conteiner-jod: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_JOD} \
	    IMAGETMP_VERSION=$(IMAGE_JOD_VERSION) \
		IMAGETMP_PATH=jod \
		build-conteiner-generic

## build-conteiner-solr construir imagem solr
build-conteiner-solr: verificar-imagem-solr-base
	@make IMAGETMP=${IMAGE_SOLR} \
	    IMAGETMP_VERSION=$(IMAGE_SOLR_VERSION) \
		IMAGETMP_PATH=solr \
		build-conteiner-generic

## build-conteiner-mariadb construir imagem mariadb
build-conteiner-mariadb:
	@make IMAGETMP=${IMAGE_MARIADB} \
	    IMAGETMP_VERSION=$(IMAGE_MARIADB_VERSION) \
		IMAGETMP_PATH=mariadb \
		build-conteiner-generic

## build-conteiner-nginx construir imagem nginx cacheassets
build-conteiner-nginx:
	@make IMAGETMP=${IMAGE_NGINX} \
	    IMAGETMP_VERSION=$(IMAGE_NGINX_VERSION) \
		IMAGETMP_PATH=nginx \
		build-conteiner-generic

## build-conteiner-all-base construir todas as imagens base (alpine e solr-base)
build-conteiner-base-all:
	@make build-conteiner-alpine
	@make build-conteiner-memcached-base
	@make build-conteiner-solr-base
	@make build-conteiner-mariadb-base

## build-conteiner-all construir todas as imagens (exceto as imagens base)
build-conteiner-all:
	@make build-conteiner-phpmaketools
	@make build-conteiner-apache
	@make build-conteiner-php
	@make build-conteiner-php-cron
	@make build-conteiner-php-install
	@make build-conteiner-apache-php
	@make build-conteiner-memcached
	@make build-conteiner-jod
	@make build-conteiner-solr
	@make build-conteiner-mariadb
	@make build-conteiner-nginx


#*****************************************************
#*******PUBLISH CONTAINERS TARGETS********************
#*****************************************************

## publish-container-generic: target generico para publicar imagem passada via parametro
publish-container-generic: verificar-docker-registry
	@if test -z "$$(docker images -q $(IMAGEMTMP_FULL))"; then \
		echo "Imagem $(IMAGEMTMP_FULL) nao existe. Rode o build respectivo antes"; \
		exit 1; \
	else \
		echo "Publicando a imagem: $(IMAGEMTMP_FULL)"; \
		echo "Caso nao publique verifique se vc esta logado no registry informado no seu env"; echo ""; \
		set -e; \
		docker push $(IMAGEMTMP_FULL); \
	fi;

## publicar imagem alpine
publish-container-alpine:
	@make IMAGEMTMP_FULL=$(IMAGE_ALPINE):$(IMAGE_ALPINE_VERSION) publish-container-generic

## publicar imagem memcached-base
publish-container-memcached-base:
	@make IMAGEMTMP_FULL=$(IMAGE_MEMCACHED_BASE):$(IMAGE_MEMCACHED_BASE_VERSION) publish-container-generic

## publicar imagem solr-base
publish-container-solr-base:
	@make IMAGEMTMP_FULL=$(IMAGE_SOLR_BASE):$(IMAGE_SOLR_BASE_VERSION) publish-container-generic

# publicar imagem mariadb-base
publish-container-mariadb-base:
	@make IMAGEMTMP_FULL=$(IMAGE_MARIADB_BASE):$(IMAGE_MARIADB_BASE_VERSION) publish-container-generic

## publicar imagem phpmaketools
publish-container-phpmaketools:
	@make IMAGEMTMP_FULL=$(IMAGE_APOIO_PHP):$(IMAGE_APOIO_PHP_VERSION) publish-container-generic

## publicar imagem apache
publish-container-apache:
	@make IMAGEMTMP_FULL=$(IMAGE_APACHE):$(IMAGE_APACHE_VERSION) publish-container-generic

## publicar imagem php
publish-container-php:
	@make IMAGEMTMP_FULL=$(IMAGE_PHP):$(IMAGE_PHP_VERSION) publish-container-generic

## publicar imagem php-cron
publish-container-php-cron:
	@make IMAGEMTMP_FULL=$(IMAGE_PHP_CRON):$(IMAGE_PHP_CRON_VERSION) publish-container-generic

## publicar imagem php-install
publish-container-php-install:
	@make IMAGEMTMP_FULL=$(IMAGE_PHP_INSTALL):$(IMAGE_PHP_INSTALL_VERSION) publish-container-generic

## publicar imagem apache-php
publish-container-apache-php:
	@make IMAGEMTMP_FULL=$(IMAGE_APACHE_PHP):$(IMAGE_APACHE_PHP_VERSION) publish-container-generic

## publicar imagem memcached
publish-container-memcached:
	@make IMAGEMTMP_FULL=$(IMAGE_MEMCACHED):$(IMAGE_MEMCACHED_VERSION) publish-container-generic

## publicar imagem jod
publish-container-jod:
	@make IMAGEMTMP_FULL=$(IMAGE_JOD):$(IMAGE_JOD_VERSION) publish-container-generic

## publicar imagem solr
publish-container-solr:
	@make IMAGEMTMP_FULL=$(IMAGE_SOLR):$(IMAGE_SOLR_VERSION) publish-container-generic

## publicar imagem mariadb
publish-container-mariadb:
	@make IMAGEMTMP_FULL=$(IMAGE_MARIADB):$(IMAGE_MARIADB_VERSION) publish-container-generic

## publicar imagem nginx
publish-container-nginx:
	@make IMAGEMTMP_FULL=$(IMAGE_NGINX):$(IMAGE_NGINX_VERSION) publish-container-generic

## publish-all-base: target para publicar as imagens base (alpine e solr-base)
publish-all-base:
	@make publish-container-alpine
	@make publish-container-memcached-base
	@make publish-container-solr-base
	@make publish-container-mariadb-base

## publish-all: target para publicar todas as imagens (exceto as imagens base)
publish-all:
	@make publish-container-phpmaketools
	@make publish-container-apache
	@make publish-container-php
	@make publish-container-php-cron
	@make publish-container-php-install
	@make publish-container-apache-php
	@make publish-container-memcached
	@make publish-container-jod
	@make publish-container-solr
	@make publish-container-mariadb
	@make publish-container-nginx



#####################################################
##
#####################################################

## buildx-conteiner-generic: target generico para construir imagens multiplataforma passadas por parametro
buildx-conteiner-generic: verificar-docker-registry verificar-parametro-imagemtmp-path
	@make IMAGETMP=$(IMAGETMP) IMAGETMP_VERSION=$(IMAGETMP_VERSION) verificar-conteiner-imagem-rodando
	docker buildx build --platform $(DOCKER_MULTIPLATFORM) --push $(DOCKER_CACHE_ARG) --progress=plain $(BUILD_ARGS) -t $(IMAGETMP):$(IMAGETMP_VERSION) $(IMAGETMP_PATH)

## buildx-conteiner-generic2: target generico para construir imagens multiplataforma passadas por parametro
buildx-conteiner-generic2: verificar-docker-registry verificar-parametro-imagemtmp-path
	@make IMAGETMP=$(IMAGETMP) IMAGETMP_VERSION=$(IMAGETMP_VERSION) verificar-conteiner-imagem-rodando
	docker buildx build --platform $(DOCKER_MULTIPLATFORM) --push $(DOCKER_CACHE_ARG) --progress=plain $(BUILD_ARGS) -t $(IMAGETMP):$(IMAGETMP_VERSION) --target $(IMAGETMP_TARGET) $(IMAGETMP_PATH)

## construir imagem alpine. Necessario rodar apenas uma vez por registry
buildx-conteiner-alpine:  verificar-imagem-alpine-params
	@make IMAGETMP=$(IMAGE_ALPINE) \
		IMAGETMP_VERSION=$(IMAGE_ALPINE_VERSION) \
		IMAGETMP_PATH=alpine \
		buildx-conteiner-generic

## construir imagem solr-base. Necessario rodar apenas uma vez por registry
buildx-conteiner-solr-base:
	@make IMAGETMP=$(IMAGE_SOLR_BASE) \
		IMAGETMP_VERSION=$(IMAGE_SOLR_BASE_VERSION) \
		IMAGETMP_PATH=solr-base \
		buildx-conteiner-generic

## construir imagem memcached-base. Necessario rodar apenas uma vez por registry
buildx-conteiner-memcached-base:
	@make IMAGETMP=$(IMAGE_MEMCACHED_BASE) \
		IMAGETMP_VERSION=$(IMAGE_MEMCACHED_BASE_VERSION) \
		IMAGETMP_PATH=memcached-base \
		buildx-conteiner-generic

## construir imagem mariadb-base. Necessario rodar apenas uma vez por registry
buildx-conteiner-mariadb-base:
	@make IMAGETMP=$(IMAGE_MARIADB_BASE) \
		IMAGETMP_VERSION=$(IMAGE_MARIADB_BASE_VERSION) \
		IMAGETMP_PATH=mariadb-base \
		buildx-conteiner-generic

## buildx-conteiner-apache construir imagem apache
buildx-conteiner-apache: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_APACHE} \
	    IMAGETMP_VERSION=$(IMAGE_APACHE_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=apache \
		buildx-conteiner-generic2

## buildx-conteiner-phpmaketools construir imagem phpmaketools
buildx-conteiner-phpmaketools: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_APOIO_PHP} \
	    IMAGETMP_VERSION=$(IMAGE_APOIO_PHP_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=phpmaketools \
		buildx-conteiner-generic2

## buildx-conteiner-php construir imagem php
buildx-conteiner-php: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_PHP} \
	    IMAGETMP_VERSION=$(IMAGE_PHP_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=php \
		buildx-conteiner-generic2

## buildx-conteiner-php-cron construir imagem php-cron
buildx-conteiner-php-cron: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_PHP_CRON} \
	    IMAGETMP_VERSION=$(IMAGE_PHP_CRON_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=php-cron \
		buildx-conteiner-generic2

## buildx-conteiner-php-install construir imagem php-install
buildx-conteiner-php-install: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_PHP_INSTALL} \
	    IMAGETMP_VERSION=$(IMAGE_PHP_INSTALL_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=php-install \
		buildx-conteiner-generic2

## buildx-conteiner-apache-php construir imagem apache-php
buildx-conteiner-apache-php: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_APACHE_PHP} \
	    IMAGETMP_VERSION=$(IMAGE_APACHE_PHP_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=apachephp \
		buildx-conteiner-generic2

## buildx-conteiner-memcached construir imagem memcached
buildx-conteiner-memcached: verificar-imagem-memcached-base
	@make IMAGETMP=${IMAGE_MEMCACHED} \
	    IMAGETMP_VERSION=$(IMAGE_MEMCACHED_VERSION) \
		IMAGETMP_PATH=memcached \
		buildx-conteiner-generic

## buildx-conteiner-jod construir imagem jod
buildx-conteiner-jod: verificar-imagem-alpine verificar-app-params
	@make IMAGETMP=${IMAGE_JOD} \
	    IMAGETMP_VERSION=$(IMAGE_JOD_VERSION) \
		IMAGETMP_PATH=jod \
		buildx-conteiner-generic

## buildx-conteiner-solr construir imagem solr
buildx-conteiner-solr: verificar-imagem-solr-base
	@make IMAGETMP=${IMAGE_SOLR} \
	    IMAGETMP_VERSION=$(IMAGE_SOLR_VERSION) \
		IMAGETMP_PATH=solr \
		buildx-conteiner-generic

## buildx-conteiner-mariadb construir imagem mariadb
buildx-conteiner-mariadb:
	@make IMAGETMP=${IMAGE_MARIADB} \
	    IMAGETMP_VERSION=$(IMAGE_MARIADB_VERSION) \
		IMAGETMP_PATH=mariadb \
		buildx-conteiner-generic

## buildx-conteiner-nginx construir imagem nginx cacheassets
buildx-conteiner-nginx:
	@make IMAGETMP=${IMAGE_NGINX} \
	    IMAGETMP_VERSION=$(IMAGE_NGINX_VERSION) \
		IMAGETMP_PATH=nginx \
		buildx-conteiner-generic

## buildx-conteiner-all-base construir todas as imagens base (alpine e solr-base)
buildx-conteiner-base-all:
	@make buildx-conteiner-alpine
	@make buildx-conteiner-memcached-base
	@make buildx-conteiner-solr-base
	@make buildx-conteiner-mariadb-base

## build-conteiner-all construir todas as imagens (exceto as imagens base)
buildx-conteiner-all:
	@make buildx-conteiner-phpmaketools
	@make buildx-conteiner-apache
	@make buildx-conteiner-php
	@make buildx-conteiner-php-cron
	@make buildx-conteiner-php-install
	@make buildx-conteiner-apache-php
	@make buildx-conteiner-memcached
	@make buildx-conteiner-jod
	@make buildx-conteiner-solr
	@make buildx-conteiner-mariadb
	@make buildx-conteiner-nginx