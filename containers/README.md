

# Containers

⚠️ **Atenção:**

O fonte do SEI é privado. Portanto jamais use um registry público para salvar as imagens.
Você é responsável pela proteção do registry que vai abrigar as imagens com o código fonte do SEI.

## Para Buildar os Containers

### Passo 1

Entre na pasta containers e vamos disponibilizar o arquivo envcontainers.env que terá as diretrizes do build

```
cd containers
make getenv
```

Entre no envcontainers.env e faça os ajustes de acordo com a sua necessidade.
Entre os itens a serem ajustados observe:
- DOCKER_REGISTRY aponte para o seu registry privado
- DOCKER_MULTIPLATFORM para o caso de desejar buildar as imagens para várias arquiteturas diferentes
- GIT_SEI_URL aponte para o seu git privado (ou o nosso git privado caso possua o ACT do PEN)
- GIT_SEI_PAT personal access token usado para baixar os dados do git privado

Existem diversas outras variáveis a serem ajustadas que vc poderá usar de acordo com a ocasião.

### Passo 2

Construir imagens base que vão servir de apoio para outras imagens

```
make build-conteiner-base-all
```

### Passo 3

Construir imagem phpmaketools, responsável por nos ajudar a baixar os fontes e prepará-los para o build no conteiner oficial

```
make build-conteiner-phpmaketools
```

### Passo 4

Baixar o fonte do git informado no envcontainers.env.

Caso não queira usar um git para os fontes, então providencie os arquivos do Sei já com os módulos diretamente na pasta
app/assets/fontes/fontes-sei e proceda para o passo seguinte.

Observe que nesta pasta devem estar diretamente as pastas infra, sei e sip, sem os arquivos de ConfiguracaoSei.php e ConfiguracaoSip.php. Os módulos já devem estar corretamente posicionados dentro de sei/web/modulos e também sem os arquivos de configuração caso existam.

### Passo 5

Preparar os fontes para o build das imagens web e php

```
make fontesPrepare
```

### Passo 6

Agora podemos buildar cada imagem idependentemente ou então todas elas rodando:
```
make build-conteiner-all
```

Para buildar uma imagem independentemente basta rodar o seu make equivalente:
por ex: make build-conteiner-php-cron


### Passo 7

Vamos publicar as imagens no registry

```
make publish-all-base
make publish-all
```

## Para Builds Multiplataforma

Caso deseje buildar imagens multiplataforma:
```
make buildx-conteiner-base-all
make buildx-conteiner-all
```

Quando o build é feito para multiplataforma não precisa fazer o push/publish. O push é feito automaticamente.
Obviamente seu docker deverá estar configurado para fazer multibuild platform.


# Vídeo Tutoriais

Para conveniência, acompanhe, via vídeo tutorial, a construção dos conteineres. [Clique Aqui](../docs/videotutoriais.md)