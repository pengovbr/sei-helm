# Helm

## Visão Macro dos Componentes

Aqui uma visão macro da arquitetura:

![enter image description here](https://raw.githubusercontent.com/pengovbr/sei-helm-repo/refs/heads/main/prd/visaoGeral01.png)

[Clique Aqui](../docs/visaocomponentes.md) para uma descrição mais completa de todos os componentes.


## Publicação:

Uma vez as imagens publicadas em seu registry privado, para subir o helm proceda da sequinte forma:

### Preparação do Kube:

- Planeje os namespaces separadamente: cada componente ou grupo de componentes deverá obrigatoriamente estar em seu namespace separado. Você pode informar o namespace no comando de criação do helm chart. Na figura acima temos os seguintes namespaces:
	- app1, app2 e app3 - contendo apache, php memcached, agendador e os jobs de instalacao para cada instância
	- cacheassets1 - contendo o serviço de cache de assets compartilhado entre as instancias
	- db1 - contendo um database compartilhado entre as instâncias
	- solr1 - contendo um solr compartilhado entre as instâncias
	- jod1 - contendo um jod compartilhado entre as instâncias

- Você pode, por exemplo criar um db2 e uma ou mais instâncias futuras compartilharem ele.

- Namespace default não deverá ser usado. Uma url diferente de localhost também é obrigatório. Caso esteja local, pode usar o recurso do /etc/hosts para testes, mas sempre com uma url diferente de localhost.

- Ingress nginx habilitado

- Métricas habilitado (para os hpas)

- StorageClass NFS ou outro compartilhador de Volumes

- Prover um secret para o seu registry. É ele que o kube usará para baixar as imagens. Deverá estar disponível em cada namespace. O nome default é secregistry, mas você poderá usar outro nome, basta informá-lo no arquivo Values de cada chart
- Prover um secret com o certificado para cada namespace de aplicação e informá-lo no Values de cada chart. O nome default é mysecret, mas vc pode usar outro. Vc também poderá usar o letsencrypt; basta usar as anotações opcionais no Values do helm chart equivalente

- Nesta primeira versão as afinidades deverão ser inseridas a nível de namespace. Cada componente respeitará a afinidade que foi definida


## Preparar Arquivos Values para Charts

Seguindo o padrão helm chart de publicação, você deverá prover um arquivo Values para cada chart que quiser publicar.

Cada chart tem um arquivo Values com informações do que você pode alterar de acordo com o seu ambiente.

Verifique em cada um deles as orientações para preenchimento.

## Publicar cada Chart Individualmente

Depois de tudo preparado publique os charts individualmente usando os comandos helm para tal.

Ex para publicação do Solr usando um Values customizado:
```
cd helm
helm install solr charts/sei-solr -n mysolr --create-namespace -f ~/Desktop/clustervalues/meusei.br/solr.yaml
```



## Solr - Adicionar Novos Orgãos

Caso deseje inserir novas instâncias de SEI no Cluster, você precisará fazer um upgrade no Solr contendo os índices e usuários para as novas instâncias. Ajuste o arquivo Values com os dados do novo índice (nome, usuário e senha a serem usados pela instancia) e rode o comando, por ex:

helm upgrade solr charts/sei-solr -n mysolr -f ~/Desktop/clustervalues/meusei.br/solr.yaml

Esse upgrade vai escalonar um novo job kubernetes no solr para criar o novo índice e provisionar o user/senha desejado.

## Cache Assets - Adicionar Novos Orgãos

Situação análoga a do Solr acima


# Vídeo Tutoriais

Para conveniência, acompanhe, via vídeo tutorial, a subida de alguns ambientes de teste. [Clique Aqui](../docs/videotutoriais.md)
