pipeline {
    agent {
        node{
            label 'maven'
        }
    }
    environment{
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }
    def registry = 'https://xiangli.jfrog.io'
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
        stage("JFrog Artifactory Publish") {
            steps {
                script {
                    echo '<--------------- JFrog Publish Started --------------->'
                    def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"Jfrog-token"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                    def uploadSpec = """{
                                            "files": [
                                                        {
                                                        "pattern": "jarstaging/(*)",
                                                        "target": "xianglimaven-libs-release-local/{1}",
                                                        "flat": "false",
                                                        "props" : "${properties}",
                                                        "exclusions": [ "*.sha1", "*.md5"]
                                                        }
                                                    ]
                                        }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '<--------------- JFrog Publish Ended --------------->'  
                }
            }   
        }
        stage(" Docker Build ") {
            def imageName = 'xiangli.jfrog.io/xiangli-docker-repo-docker/ttrend'
            def version   = '2.0.2'
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build(imageName+":"+version)
                    echo '<--------------- Docker Build Ends --------------->'
                }
            }
        }

        stage (" Docker Publish "){
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'  
                    docker.withRegistry(registry, 'artifactory_token'){
                        app.push()
                    }    
                    echo '<--------------- Docker Publish Ended --------------->'  
                }
            }
        }
    }
}