SHELL := /bin/bash

ifneq ("$(wildcard envcontainers.env)","")
include envcontainers.env
endif

BUILD_ARGS := $(shell apoio/scripts/get_build_args.sh)


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
	    echo "Imagem $(IMAGETMP) está sendo usada ou ainda persiste no pool docker stopada."; \
			echo "Pare e remova antes o conteiner. Abandonando execucao..."; \
			echo ""; echo ""; \
	exit 1; \
	fi

verificar-docker-registry: ## target de apoio para verificar se a variavel DOCKER_REGISTRY E VERSION foram informadas
	@if [ -z "$(DOCKER_REGISTRY)" ]; then echo "Var DOCKER_REGISTRY nao definida"; make envcontainers.env; exit 1; fi

verificar-imagem-alpine-params: ## target de apoio para verificar se a imagem alpine foi informada
	@if [ -z "$(IMAGE_ALPINE)" ]; then echo "Var IMAGE_ALPINE nao definida"; make envcontainers.env; fi
	@if [ -z "$(IMAGE_ALPINE_VERSION)" ]; then echo "Var IMAGE_ALPINE_VERSION nao definida"; exit 1; fi
	@if [ -z "$(ALPINE_ORIGINAL_VERSION)" ]; then echo "Var ALPINE_ORIGINAL_VERSION nao definida"; exit 1; fi

verificar-app-params: ## target de apoio para verificar se token git foi passado
	@if [ -z "$(GIT_SEI_PAT)" ]; then echo "Informe GIT_SEI_PAT"; exit 1; fi
	@if [ -z "$(GIT_SEI_URL)" ]; then echo "Informe GIT_SEI_URL"; exit 1; fi
	@if [ -z "$(GIT_SEI_VERSION)" ]; then echo "Informe GIT_SEI_VERSION"; exit 1; fi


getenv: ## target de apoio para copiar o arquivo envcontainers.env baseado no modelo envcontaners.env.modelo
		@cp -f envcontainers.env.modelo envcontainers.env
		@echo "Arquivo envcontainers.env criado com valores default.";
		@echo "Abra o arquivo e faca as alteracoes para o seu ambiente.";

envcontainers.env: ## target de apoio para verificar se existe arquivo envcontaners.env
		@echo "Nao encontrado arquivo env para as operacoes de containeres."
		@echo "Ha um arquivo modelo (envcontainers.env.modelo) que vc pode usar para preencher com suas informacoes."
		@echo "Basta rodar make getenv"
		@echo "Em seguida, altere nesse arquivo as informacoes para o seu ambiente"
		exit 1

getexample: ## traz o arquivo de exemplo caso o titular n exista
	@if [ ! -f "$(arq_titular)" ]; then \
	    echo "Arquivo $(arq_titular) inexistente. Vamos usar o arquivo de exemplo $(arq_example)"; \
		cp $(arq_example) $(arq_titular); \
	fi;

## get fontes e modulos
get-fontes-modulos:
	@docker run -it --rm \
	    -v "${PWD}"/app/assets/fontes:/fontes \
		-v "${PWD}"/apoio/phpmaketools/scripts:/scripts \
		--env-file envcontainers.env $(IMAGE_APOIO_PHP):$(IMAGE_APOIO_PHP_VERSION) \
		sh -c "scripts/down_sei.sh"


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


## construir imagem alpine
build-conteiner-alpine:  verificar-imagem-alpine-params
	@make IMAGETMP=$(IMAGE_ALPINE) \
		IMAGETMP_VERSION=$(IMAGE_ALPINE_VERSION) \
		IMAGETMP_PATH=alpine \
		build-conteiner-generic

## build-conteiner-phpmaketools construir imagem build-conteiner-phpmaketools
build-conteiner-phpmaketools: verificar-imagem-alpine-params
	@make IMAGETMP=${IMAGE_APOIO_PHP} \
	    IMAGETMP_VERSION=$(IMAGE_APOIO_PHP_VERSION) \
		IMAGETMP_PATH=apoio/phpmaketools \
		build-conteiner-generic


## build-conteiner-apache construir imagem apache
build-conteiner-apache: verificar-app-params
	@make IMAGETMP=${IMAGE_APACHE} \
	    IMAGETMP_VERSION=$(IMAGE_APACHE_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=apache \
		build-conteiner-generic2


# build-conteiner-php construir imagem php
build-conteiner-php: verificar-app-params
	@make IMAGETMP=${IMAGE_PHP} \
	    IMAGETMP_VERSION=$(IMAGE_PHP_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=php \
		build-conteiner-generic2

# build-conteiner-php-cron construir imagem php-cron
build-conteiner-php-cron: verificar-app-params
	@make IMAGETMP=${IMAGE_PHP_CRON} \
	    IMAGETMP_VERSION=$(IMAGE_PHP_CRON_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=php-cron \
		build-conteiner-generic2

# build-conteiner-php-install construir imagem php-install
build-conteiner-php-install: verificar-app-params
	@make IMAGETMP=${IMAGE_PHP_INSTALL} \
	    IMAGETMP_VERSION=$(IMAGE_PHP_INSTALL_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=php-install \
		build-conteiner-generic2

# build-conteiner-apache-php construir imagem apache-php
build-conteiner-apache-php: verificar-app-params
	@make IMAGETMP=${IMAGE_APACHE_PHP} \
	    IMAGETMP_VERSION=$(IMAGE_APACHE_PHP_VERSION) \
		IMAGETMP_PATH=app \
		IMAGETMP_TARGET=apachephp \
		build-conteiner-generic2

# build-conteiner-memcached construir imagem memcached
build-conteiner-memcached: verificar-app-params
	@make IMAGETMP=${IMAGE_MEMCACHED} \
	    IMAGETMP_VERSION=$(IMAGE_MEMCACHED_VERSION) \
		IMAGETMP_PATH=memcached \
		build-conteiner-generic

# build-conteiner-jod construir imagem jod
build-conteiner-jod: verificar-app-params
	@make IMAGETMP=${IMAGE_JOD} \
	    IMAGETMP_VERSION=$(IMAGE_JOD_VERSION) \
		IMAGETMP_PATH=jod \
		build-conteiner-generic

# build-conteiner-solr construir imagem solr
build-conteiner-solr: verificar-app-params
	@make IMAGETMP=${IMAGE_SOLR} \
	    IMAGETMP_VERSION=$(IMAGE_SOLR_VERSION) \
		IMAGETMP_PATH=solr \
		build-conteiner-generic

# build-conteiner-mariadb construir imagem mariadb
build-conteiner-mariadb: verificar-app-params
	@make IMAGETMP=${IMAGE_MARIADB} \
	    IMAGETMP_VERSION=$(IMAGE_MARIADB_VERSION) \
		IMAGETMP_PATH=mariadb \
		build-conteiner-generic

# build-conteiner-nginx construir imagem nginx cacheassets
build-conteiner-nginx: verificar-app-params
	@make IMAGETMP=${IMAGE_NGINX} \
	    IMAGETMP_VERSION=$(IMAGE_NGINX_VERSION) \
		IMAGETMP_PATH=nginx \
		build-conteiner-generic

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


publish-container-alpine: ## publicar imagem alpine
	@make IMAGEMTMP_FULL=$(IMAGE_ALPINE):$(IMAGE_ALPINE_VERSION) publish-container-generic

publish-container-phpmaketools: ## publicar imagem phpmaketools
	@make IMAGEMTMP_FULL=$(IMAGE_APOIO_PHP):$(IMAGE_APOIO_PHP_VERSION) publish-container-generic

publish-container-app-apache: ## publicar imagem app-apache
	@make IMAGEMTMP_FULL=$(IMAGE_APP_APACHE):$(IMAGE_APP_APACHE_VERSION) publish-container-generic

publish-container-app-php: ## publicar imagem app-php
	@make IMAGEMTMP_FULL=$(IMAGE_APP_PHP):$(IMAGE_APP_PHP_VERSION) publish-container-generic

publish-container-app-php-cron: ## publicar imagem app-php-cron
	@make IMAGEMTMP_FULL=$(IMAGE_APP_PHP_CRON):$(IMAGE_APP_PHP_CRON_VERSION) publish-container-generic

publish-container-app-php-install: ## publicar imagem app-php-install
	@make IMAGEMTMP_FULL=$(IMAGE_APP_PHP_INSTALL):$(IMAGE_APP_PHP_INSTALL_VERSION) publish-container-generic

publish-container-app-apache-php: ## publicar imagem app-apache-php
	@make IMAGEMTMP_FULL=$(IMAGE_APP_APACHE_PHP):$(IMAGE_APP_APACHE_PHP_VERSION) publish-container-generic

publish-container-memcached: ## publicar imagem memcached
	@make IMAGEMTMP_FULL=$(IMAGE_MEMCACHED):$(IMAGE_MEMCACHED_VERSION) publish-container-generic

publish-container-jod: ## publicar imagem jod
	@make IMAGEMTMP_FULL=$(IMAGE_JOD):$(IMAGE_JOD_VERSION) publish-container-generic

publish-container-solr: ## publicar imagem solr
	@make IMAGEMTMP_FULL=$(IMAGE_SOLR):$(IMAGE_SOLR_VERSION) publish-container-generic

publish-container-mariadb: ## publicar imagem mariadb
	@make IMAGEMTMP_FULL=$(IMAGE_MARIADB):$(IMAGE_MARIADB_VERSION) publish-container-generic

publish-container-nginx: ## publicar imagem nginx
	@make IMAGEMTMP_FULL=$(IMAGE_NGINX):$(IMAGE_NGINX_VERSION) publish-container-generic