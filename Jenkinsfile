pipeline {
    agent {
        label 'maven'
    }
    stages {
        stage('build') {
            steps {
                echo 'Building the application...'
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo 'Build completed successfully!'
            }
        }

        stage('test') {
            steps {
                echo 'Running unit tests...'
                sh 'mvn surefire-report:report'
                echo 'Unit tests completed!'
            }
        }

        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'ttrend-sonarqube-scanner' // Use '=' for assignment
            }
            steps {
                script {
                    withSonarQubeEnv('sonarqube-server') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
    }
}
