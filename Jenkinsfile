pipeline {
    agent {
        node{
            label 'maven'
        }
    }

    stages {
        stage('clone code') {
            steps {
                git branch: 'main', url: 'https://github.com/Jayraj0042/tweet-trend-new.git'
            }
        }
    }
}