pipeline {
    agent any

    tools {
     jdk 'JDK 17'
     maven 'maven3'
    }

    environment{
        SCANNER_HOHE= tool 'sonar-scanner'
    }
    stages {
        stage('Git Checkout') {
            steps {
                 git branch: 'main', url: 'https://github.com/hemanthSel/springit'
            }
        }

        // clean removes the target/ directory (compiled code and artifacts).
        stage('Integration Test') {
            steps {
                sh "mvn clean install -DskipTests=true"
            }
        }

        // mvn compile runs the Maven compile phase, which compiles the project's source code.
        stage('Maven Compile') {
            steps {
                echo "Maven Compile started..."
                sh "mvn compile"
            }
        }

        stage('SonarQube-Analysis') {
            steps {
                script {
                 echo "sonarqube code analysis"
                 withSonarQubeEnv(credentialsId: 'sonar-token') {
                     sh ''' $SCANNER_HOHE/bin/sonar-scanner -Dsonar.projectName=spring-boot-  -Dsonar.projectKey=springboot-java \
                     -Dsonar.java.binaries=. '''
                     echo "End of sonarqube code analysis"

                   }
                }
            }
        }

        // Compiles the code and packages it into a JAR/WAR file inside the target/ directory.
        stage('Mvn Build') {
            steps {
              sh "mvn package"
            }
        }

        // Authenticates with DockerHub (or another registry) using credentials stored in Jenkins (docker-cred).
        stage('Docker Images') {
            steps {
                script {
                 echo "Docker Image started..."
                    // sh "sudo usermod -aG docker $USER"
                    //  sh "newgrp docker"
                    //  sh "groups"
                     // sh "sudo chmod 777 /var/run/docker.sock"
                 withDockerRegistry(credentialsId: 'dockerID', toolName: 'docker') {
                    sh "docker build -t java-one ."
                    sh 'docker images'
                 }
                 echo "End of Docker Images"
                }
            }
        }

        stage("Tag & Push to DockerHub"){
            steps{
                script {
                    echo "Tag & Push to DockerHub Started..."
                    withDockerRegistry(credentialsId: 'dockerID', toolName: 'docker') {
                      sh "docker tag devops-one hemanth509/java-one:V1.001"
                      sh "docker push hemanth509/java-one:V1.001"
                      sh 'docker images'
                    }
                    echo "End of Tag & Push to DockerHub"
                }
            }
        }
        stage('Verify Trivy Installation') {
            steps {
                echo "Trivy version check"
                sh 'export HOME=/var/root/jenkins'
              //  sh 'trivy --version'
            }
        }
        stage('Docker Image Scan') {
            steps {
                sh "trivy image hemanth509/java-one:V1.001"
            }
        }

    }
}