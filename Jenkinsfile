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
                // sh 'mvn clean deploy'
                echo "----------- build complted ----------"
            }
        }
    }
}