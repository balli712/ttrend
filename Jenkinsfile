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
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "----------- build complted ----------"
            }
        }
        stage("Test Stage"){
            steps{
                echo "----------- unit test started ----------"
                sh 'mvn surefire-report:report'
                echo "----------- unit test Complted ----------"
            }
        }
        stage('SonarQube Analysis Stage'){
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
        stage("Validate Quality Gate"){
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
                        def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
    }
}