# SEI-Helm

A partir de abril de 2026 o foco deste projeto será ambientes SEI em produção.

Ele faz parte de um objetivo maior que é o projeto de **Provisionamento em Larga Escala para o SEI**,  que tem entre seus requisitos a automação das atividades de provisionamento/instalação e atualização das versões do SEI e seus módulos usando um modelo gitops.

O SEI-Helm é a coluna principal que irá sustentar esse novo ecossistema, a permitir por exemplo, a disponibilização automática de dezenas de instâncias do SEI compartilhando os recursos de um mesmo Database, Solr e outros componentes.

---
**Obs:**
Caso esteja buscando o antigo projeto Helm, baseado no sei-docker para ambientes de teste, dirija-se aqui: https://github.com/pengovbr/sei-helm-dev



## O que é

O SEI-Helm disponibiliza pacotes para instalar o SEI e seus componentes em cluster kubernetes usando o https://helm.sh/

Roda de forma portátil no seu cluster permitindo gerenciar a instalação e compartilhando recursos, como por exemplo a possibilidade de subir várias instâncias do SEI compartilhando um único banco de dados, Jod, Solr, etc.

Aqui no SEI-Helm temos:
- receitas sugestivas para conteineres de produção
- receitas kubernetes para os componentes do SEI
- charts helm para o provisionamento do SEI

**Importante**
Esta é uma versão release candidate. Para maiores informações veja a seção **Limitações** abaixo.


## Para quem

Permite a profissionais de infra subirem no kubernetes, rapidamente, uma ou várias instâncias do SEI usando a abordagem do Helm.

Embora possa perfeitamente ser utilizada isoladamente, esta solução será melhor aproveitada quando disponibilizarmos a segunda parte do projeto que terá o ArgoCd / Jenkins participando da orquestração e usando o modelo gitops de provisionamento.



## Para que


Ambientes do SEI no kubernetes:

- teste

- treinamento

- produção



# Limitações

Esta é uma primeira versão que a equipe considera o pontapé inicial para instalações em prd.
Ela ainda é release candidate, pois, por falta de recurso e tempo ainda nos faltam diversos aspectos a serem melhor desenvolvidos como:
- testar em ambiente real (nós ainda não temos infra análoga a prd para testes)
- testes de carga
- testes de segurança

Qualquer uso desse repositório para prd deverão ser observadas todas as práticas pertinentes a ambientes produtivos no que se refere a backup, segurança, monitoramento, etc.

Ao longo do desenvolvimento e a depender do RoadMap iremos adicionar mais elementos nesse sentido aqui no helm ou em projetos side-kick no nosso repositório: https://github.com/pengovbr

Antes do uso em prd, deve-se organizar um projeto piloto com observabilidade e também acesso reduzido. Como o projeto é novo podem ser necessários ajustes além de correções.

Até a data da liberação dessa versão do Helm, o SEI 5.1 estava compatível com os módulos: estatísticas, tramita, assinatura e resposta. Por isso nesta versão é compatível apenas com esses módulos. A medida que a compatibilidade for aumentando iremos disponibilizar também outros módulos. A instalação dos módulos é opcional, podendo ou não ser ativadas na subida do helm.

Nesta versão ainda não disponibilizamos os jobs para atualização dos módulos já instalados. Uma vez estando pronta essa funcionalidade, a atualização ocorrerá simplesmente com um simples comando "helm upgrade".



# Organização


## Pasta Containers

Nesta pasta encontram-se as receitas dos containeres e tb o makefile para construirmos tudo de forma automatizada.
Na pasta "containers" há o Readme com maiores informações técnicas.

[Clique Aqui](containers/README.md) para containers.


## Pasta Helm

Nessa pasta encontramos as receitas kubernetes/helm.
Também há uma pasta "testes". Serve para testar de forma automatizada eventuais alterações feitas nos charts e garantir que o básico continua funcionando como esperado

Diversas considerações técnicas são encontradas no Readme dentro dessa pasta.

[Clique Aqui](helm/README.md) para helm.


# Pré-requisitos Gerais


- kubernetes (testado em v1.34.1)
- helm (testado no 4.1)
- ingress nginx instalado no cluster
- service metrics instalado no cluster
- código fonte do SEI e módulos desejável em repositório git
- necessário conhecimento em helm e kubernetes
- registry docker privado
- pacote make habilitado no seu SO local para rodar os builds

Também deverão ser observados para prd, diversos conhecimentos e profissionais (não exaustivamente) envolvendo:
- banco
- rede
- backup
- monitoramento
- sustentação
- segurança




# Dúvidas Sugestões Bugs ou Contribuição


Dúvidas, sugestões ou reporte de bugs usar a parte de issues: https://github.com/pengovbr/sei-helm/issues

Para contribuir basta fazer o pull request. Aconselhável antes alinhar os requisitos com algum project owner.