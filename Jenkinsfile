pipeline {
    agent any
    options {
        skipDefaultCheckout()
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Build') {
            steps { sh 'bash ./scripts/build.sh' }
            post {
                success {
                    archiveArtifacts artifacts: 'dist/*.tar.gz', fingerprint: true
                }
            }
        }
        stage('Test') {
            steps { sh 'bash ./scripts/test.sh' }
        }
        stage('Deploy to Development Sandbox') {
            steps { sh 'bash ./scripts/deploy.sh development' }
        }
    }
    post {
        success { echo 'Pipeline finished successfully' }
        failure { echo 'Pipeline failed; inspect the stage logs' }
    }
}
