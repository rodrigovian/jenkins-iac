# jenkins-iac
Armazenar códigos do jenkins server


### Após instalação e configuração inicial do server
- 1. Conectar no servidor via SSH;
- 2. Executar o comando para visualizar a senha do admin do jenkins;
    - ```docker exec -ti jenkins-terraform-server cat /var/jenkins_home/secrets/initialAdminPassword```
    - ```ff1f782c9f384817ijk025db3100369b```
- 3. Criar chave ssh no conteiner;
    - ```docker exec -ti jenkins-terraform-server bash -c "ssh-keygen -q -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa"```
- 4. Copiar a chave publica para o github
    - ```docker exec -ti jenkins-terraform-server bash -c "cat ~/.ssh/id_rsa.pub"```
    - ```ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDv2Ho/Q6dxx1FFFh2snZbGRvhA9Vx4Kqk9/k0DkKnyCVk+JuVvN440SGefQeCwN4Hom8l4P8kkTCIVOErOKYfoyRi4Vq9sv4K6bVhAivSOyxHHHKxoP16gEXpngKV97cPCHHaWNQ9RsDyGpGVOxHXjPjpIenJ7F/juujb7+ud7kvaOfRBCs8MvprVNsmzIi3HPHZQXldnGIYlgJVjK+Wobv/5QWms134CoveU75506dgfY+qa/XpsyBgN0KVucaYOR9Rwhl0000kRwgQTvfI2U/+WFOS+uWBbXj+iudl1bggIAUQUKOF4KjrJOGZ7yRDET9MDqpM9aItVndS899yrXqFUjl1RrQ9hGWCPjp9Iov4EcFG9oZVcAtAtCAss4TKNbkdUT6VVVVvbJFMut+3FOESNShCU1ZeXobqHYWGBP1759TeSNt5zRPfXvJrT+IrTV6DnzhodD66Bsh4hT9XgRAz5Pq2uIBhwE3QLVHqeDTI/U6o9152bZxAmBaPytxxV4aey2/CwCzwhGB6qYkgoc6H+b5MQd9uV4tTZmu6JNGSWJP415m57Iv5hT2KlTIe+U0oaozvjWUE6r4Vy4A597UipKKOjtAKy+hDbtl80VMA6bPp2cDnqVo/wFx2r4+okmkLmjq3ZqXJYF1l9M0fqKYyWecCKzlBmLGJF24bL6uw== jenkins@059b0045aa67```
- 5. Reconhecer conexão ssh do github.com
    - ```docker exec -ti jenkins-terraform-server bash -c "ssh-keyscan github.com >> ~/.ssh/known_hosts"```
- 6. Clonar o repositório git;
    - ```docker exec -ti jenkins-terraform-server bash -c "cd ~ ; git clone git@github.com:rodrigovian/vorx-network.git"```

- 7. Acessar a interface WEB via elastip ip (Ex. http://52.22.138.98)
- 8. Colocar a senha e fazer o wizard, continuando como Administrador.
- 9. Criar um pipeline no jenkins, com o conteudo abaixo:
```
pipeline {
agent any
  stages {
    stage('Clone') {
      steps {
        git url: 'github.com:rodrigovian/vorx-network.git', branch: 'main'
      }
    }

    stage('TF Init&Plan') {
      steps {
        script {
          sh 'terraform init'
          sh 'terraform plan -out=myplan.out'
        }
      }
    }

    stage('Approval') {
      steps {
        script {
          def userInput = input(id: 'confirm', message: 'Deseja realizar um ' + params.TF_OPTION +  ' na Infraestrutura?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Acao ' + params.TF_OPTION + ' Terraform', name: 'confirm'] ])
        }
      }
    }

    stage('TF Apply') {
      steps {
          sh 'terraform apply myplan.out'
      }
    }
  }
}
```









