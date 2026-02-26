# Como Subir

Há inúmeras formas para subir os charts.
Abaixo vamos listar uma das formas para subir 2 instâncias.

Recomendações: 

- subir cada chart em seu namespace separadamente
- evite subir o chart sei-umbrella a não ser para uma observação rápida
- necessário entendimento básico do helm e kubernetes
- mesmo que use a interface gráfica da sua ferramenta, é importante saber usar o helm pela linha de comando

## Verifique o vídeo de subida rápida:

Depois de ler todo o conteúdo abaixo pode usar esse vídeo como referência, foi ele que usamos para criar o tutorial abaixo.
https://youtu.be/MhcWzpYG24I


## Código Fonte do SEI

O automatizador baixa o fonte direto de um repositório.
Como o fonte é privado caso deseje usar essa abordagem você terá que ter acesso a algum repositório git privado e ter a chave no formato abaixo:

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BfbnNzdC1rZXktdjDAAAAACG5vbmZAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
YYYYY=
-----END OPENSSH PRIVATE KEY-----
```

Gere o base64 dessa chave com o comando, substituindo "/path/da/sua/chave" pelo caminho da sua chave privada
```
cat /path/da/sua/chave > base64
```

**Caso não deseje usar essa abordagem**, então você terá que provisionar o fonte do SEI no volume vol-sei-fontes do namespace onde foi instalado o sei-app. O automatizador ficará esperando até o código fonte estar presente.


## Namespaces

Recomendamos o uso de namespaces separados para cada chart.
Embora nos arquivos values dos charts exista a possibilidade de informar ali o namespace, deixe que o helm faça esse gerenciamento. Para essa abordagem aqui deixe em branco.

## Volumes

O helm cria os PVCs (Persistent Volume Claim) automaticamente.
Para criar os PVs (Persistent Volumes), você pode informar para cada chart helm o storageClass disponível em seu cluster (NFS, gluster, filesystem, etc).
Caso deixe o storageclass em branco o kubernetes vai usar o default do seu cluster, que em boa parte deles não vai criar o volume, nesse caso você terá que criar o volume manualmente.



## Arquivos values

Cada chart tem o seu arquivo values.
Ali vai ficar a configuração de cada componente, como por exemplo o storageClass a ser usado para criar os volumes.
No values do sei-app tem dezenas de opções a serem preenchidas como: url que o sei vai atender, nome do orgao, quais módulos deseja instalar, etc


## Passo a passo da subida do ambiente na interface gráfica

Adicione ao seu gerenciador helm a seguinte url: https://pengovbr.github.io/sei-helm-repo

No seu kube crie os seguintes namespaces:

- app1
- app2
- memcached1
- memcached2
- db
- jod
- solr

Mande o helm instalar cada componente separadamente e em seu próprio namespace.

Obs, no seu cluster deve haver um provisionador de volumes default, caso contrário informe durante a instalação, para cada componente, o storageClass. Ou crie manualmente os volumes no kubernetes.
No docker-desktop do Mac e Windows com wsl ele já tem um storageclass default sem a necessidade de informar no arquivo values.

Ao subir o sei-app, altere durante a instalação os seguintes valores do arquivo values do chart:

```
storageclass: <nome da sua storageclass ou deixe em branco para default>
dbcluster: db
jodcluster: jod
solrcluster: solr
memcachedcluster: memcached1
host: sei1.teste.gov.br
orgao: ORGAO1
orgao_descricao: Orgao Helm1
nome_complemento: Orgao Helm1
fontes_git_privkey: <<chavegitdofonteseinoformatoacima>>

```

Suba um segundo sei:
```
storageclass: <nome da sua storageclass ou deixe em branco para default>
dbcluster: db
jodcluster: jod
solrcluster: solr
memcachedcluster: memcached1
host: sei1.teste.gov.br
orgao: ORGAO1
orgao_descricao: Orgao Helm1
nome_complemento: Orgao Helm1
fontes_git_privkey: <<chavegitdofonteseinoformatoacima>>

```

Caso esteja tudo certo em alguns segundos os SEIs estarão no ar.

Adicione ao seu /etc/hosts as urls, para conseguir acessar os SEIs no browser:
sei1.teste.gov.br
sei2.teste.gov.br


