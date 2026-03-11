#!/bin/sh

set -e

mkdir /opt2
cd /opt2

rm -rf /fontes/*
mkdir -p /fontes/sei \
         /fontes/sip \
         /fontes/infra

echo "******************************"
echo "******DOWNLOADING SEI*********"
echo "******************************"

git clone https://dummy:${GIT_SEI_PAT}@${GIT_SEI_URL}
cd sei
git checkout ${GIT_SEI_VERSION}

cd src

cp -R sei/* /fontes/sei/
cp -R sip/* /fontes/sip/
cp -R infra/* /fontes/infra/


cd /
rm -rf /opt2
mkdir /opt2

echo "******************************"
echo "****DOWNLOADING MODULOS*******"
echo "******************************"

echo "******************************"
echo "****DOWNLOADING ASSINATURA****"
echo "******************************"

# todo baixar a release do zip

#git clone https://dummy:${GIT_SEI_PAT}@${GIT_MODULO_ASSINATURA_URL}
#cd mod-sei-assinatura-eletronica
#git checkout ${GIT_MODULO_ASSINATURA_VERSION}

#touch docs/changelogs/CHANGELOG-1.3.0.md
#make dist

#cd dist
#yes | unzip mod-sei-assinatura-eletronica-*.zip