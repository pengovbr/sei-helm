# Charts e Seus Componentes

Nesta versão da documentação serviços de mais baixo nível do kubernetes serão detalhados posteriormente.
Abaixo os serviços de mais alto nível do Helm.


## Chart sei-app

Nesse chart encontra-se:

### ingress
Configuração Nginx para receber as requisições do Cluster e rotear para o cacheassets ou servidor web


### servidor web apache

Recebe as requisições do ingress e caso sejam php roteia-as para o serviço php

### servidor php
tratamento das requisições php

### agendador

servidor php responsável por rodar atividades períodicas referentes a instância

### job dbcreate

Opcional - job responsável por provisionar um database/esquema no banco desejado

### job chaves

Opcional - job responsável por gerar as chaves únicas de segurança para acesso ao SEI e SIP. Na instalação normal do SEI o próprio SEI gera as chaves e disponibiliza. Nesta versão o administrador decidirá qual será a sua chave.

### job install

Opcional - faz a instalação do SEI e SIP com as características de cada instância

### job modulo

Opcional por módulo - faz a instalação / configuração do módulo desejado para o SEI


## Chart sei-cacheassets

Auto provisionador para cache de assets no nginx. A requisição que vem do usuário, caso seja uma figura por exemplo, será enviada apenas uma vez para o servidor web da instância. Requisições subsequentes serão servidas pelo cache poupando a aplicação.
Ele tem uma configuração específica para apontar corretamente as instâncias vigentes. Portanto caso necessite incluir novas instâncias no serviço use o "helm upgrade" após ajuste do arquivo Values.

## Chart sei-db

Chart opcional. Você pode usar seu banco on premisse ou qualquer banco externo disponível.
Caso queira usar o fornecido pelo helm, basta tunar a sua configuração usando o arquivo Values disponível que deverá ser preenchido junto a um DBA.
Para produção é obrigatório usar um storageClass performático.

## Chart sei-jod

Chart opcional. Você pode usar um serviço Jod externo.
Caso use o fornecido, prestar atenção ao Values do chart pois tem informações preciosas da performance do JOD em prd

## Chart sei-memcached

É necessário subir um desses por instância. Será compartilhado pelos pods de php vigentes. Atenção principalmente a quantidade de memória que pode ser variável entre as instâncias


## Chart sei-solr

Chart opcional. Você pode usar um Solr externo.
Cada instância deverá ter seu conjunto único de índices.
Caso deseje inserir novas instâncias de SEI no Cluster, você precisará fazer um upgrade no Solr contendo os índices e usuários para as novas instâncias. Ajuste o arquivo Values com os dados do novo índice (nome, usuário e senha a serem usados pela instancia), sem apagar os antigos, e rode o comando, por ex:

helm upgrade solr charts/sei-solr -n mysolr -f ~/Desktop/clustervalues/meusei.br/solr.yaml

Esse upgrade vai escalonar um novo job kubernetes no solr para criar o novo índice e provisionar o user/senha desejado.