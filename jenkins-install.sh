#!/bin/bash

# Mudar para o usuário root
sudo -i

# Atualizar SO
yum update -y

# Instalar yum-utils
yum install -y yum-utils

# Instalar docker
yum install -y docker
sleep 1
usermod -aG docker ec2-user

# Baixar docker compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sleep 1
chmod +x /usr/local/bin/docker-compose
sleep 2

# Adicionar docker na inicialização e iniciar o serviço
systemctl enable --now docker.service

# Criar dockerfile para criar uma imagem do jenkins

mkdir ~/build-jenkins
pushd ~/build-jenkins
cat << __EOF__ > Dockerfile
FROM jenkins/jenkins

USER root

RUN apt-get update && apt-get install -y wget apt-utils && \
    wget --quiet https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip && \
    unzip terraform_1.0.9_linux_amd64.zip && \
    mv terraform /usr/bin && \
    rm -f terraform_1.0.9_linux_amd64.zip

USER jenkins

__EOF__

docker build -t "jenkins-terraform-server" .
sleep 1
docker run -d -p 80:8080 --name jenkins-terraform-server jenkins-terraform-server

popd

