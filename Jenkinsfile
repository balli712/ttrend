def version   = '2.1.2'
pipeline {
    agent {
        node
           {
             label 'maven'
           }
    }
environment {
    PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
            }
    stages {
         stage("build"){
            steps {
                 echo "----------- build started ----------"
                sh 'mvn clean deploy'
                 echo "----------- build complted ----------"
            }
        }   
      }
} 
