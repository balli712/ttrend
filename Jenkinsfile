pipeline {
    agent {
        node{
            label 'maven'
        }
    }
    environment{
        PATH = "/opt/apache-maven-3.9.2/bin:$PATH"
    }

    stages {
        stage('hello') {
            steps {
                echo 'hello!'
            }
        }
    }
}