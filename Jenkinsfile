pipeline {
    agent {
        node{
            label 'maven'
        }
    }
    environment{
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }

    stages {
        stage('Build Stage') {
            steps {
                echo "----------- build started ----------"
                // sh 'github webhook works!'
                sh 'sudo ln -sf /usr/lib/jvm/java-11-openjdk-amd64/bin/java /usr/bin/java'
                sh 'mvn clean deploy'
                echo "----------- build complted ----------"
            }
        }
        stage('SonarQube Analysis'){
            environment{
                scannerHome = tool 'sonar-scanner'
            }  
            
            steps{
                sh 'sudo ln -sf /usr/lib/jvm/java-17-openjdk-amd64/bin/java /usr/bin/java'
                withSonarQubeEnv('sonarqube-server'){
                    sh '${scannerHome}/bin/sonar-scanner'
                }
                
            }
        }
    }
}