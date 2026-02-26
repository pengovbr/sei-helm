# SEI-Helm

Caso possua um gerenciador de pacotes helm instalado no seu cluster adicione o seguinte repositório:
https://pengovbr.github.io/sei-helm-repo



## O que é

O SEI-Helm disponibiliza pacotes para instalar o SEI e seus componentes em cluster kubernetes usando o https://helm.sh/

Roda de forma portátil no seu cluster permitindo gerenciar a instalação e compartilhando recursos, como por exemplo a possibilidade de subir várias instâncias do SEI compartilhando um único banco de dados, Jod e Solr. Atualmente usa o sei-docker como background portanto **essa versão não é recomendada em produção**.

## Para quem

Permite a profissionais de infra subirem no kubernetes rapidamente uma ou várias instâncias do SEI apenas rodando o comando "helm install" ou usando a interface GUI Helm package instalado em seu cluster.

## Para que

Ambientes do SEI no kubernetes:
- teste
- treinamento
- homologação

Está também no roadmap a implementação de algo mais próximo de produção, vamos aguardar o  andamento dos trabalhos, em breve publicaremos resultados

# Organização

Como é a primeira versão ainda podem ocorrer muitas alterações no projeto, portanto vamos explicar aqui apenas a organização dos pacotes (charts).

Charts:

- SEI-DB: banco mariadb, pode ser compartilhado entre várias instâncias
- SEI-Solr: serviço de indexação do SEI, pode ser compartilhado entre várias instâncias
- SEI-Jod: exportador de pdf para documentos do Office, LibreOffice, pode ser compartilhado entre várias instâncias
- SEI-Memcached: serviço de cache, com possibilidade de guardar a sessão do apache permitindo eliminar o uso do sticky session
- SEI-App: sobe o php8 para o SEI auto escalável bem como prover jobs para instalar o SEI e módulos; sobe ingress
- Chart-Generico-dev: SEI-Umbrella. Esse é um chart único que engloba todos os outros, adicionamos por conveniência, mas não recomendamos o seu uso a não ser para algum teste específico. Sempre opte por subir os componentes separados, desta forma o helm vai controlar a instalação e atualização dos ambientes separadamente. Caso suba o pacote umbrella, ao desinstalá-lo o helm irá destruir todo o ecossistema inclusive o banco de dados minando o compartilhamento entre várias instâncias.

Outros pacotes serão adicionados ao longo do tempo como:
- serviço varnish para cache de assets (jpg, css, js, etc)
- possibilidade de uso do ingress traefik
- serviços para gerenciamento dos recursos
- backup automatizado para atualizações
- e outros

# Pré-requisitos

- kubernetes (testado em v1.23.16 no rancher 1.2.6 e 1.32.2 no docker-desktop)
- ingress nginx instalado
- service metrics instalado caso deseje hpa
- helm (testado no 3.17)
- código fonte do SEI desejável em repositório git
- necessário conhecimento básico do helm e kubernetes


# Como subir

Uma orientação básica de como subir [está aqui](documentation/exemplo1.md)


  
# Dúvidas Sugestões Bugs ou Contribuição

Dúvidas, sugestões ou reporte de bugs usar a parte de issues: https://github.com/pengovbr/sei-helm/issues

Para contribuir basta fazer o pull request. Aconselhável antes alinhar os requisitos com algum project owner.