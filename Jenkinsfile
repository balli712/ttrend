pipeline {
    agent {
        node{
            label 'maven'
        }
    }
environment{
    PATH = "/opt/apache-maven-3.9.8/bin:$PATH"    //Define a path in slave system where the mvn jobs in run. Set variable with extra variable
}

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
}
