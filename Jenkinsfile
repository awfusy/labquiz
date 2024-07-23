pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git url: 'http://172.26.0.3:3000/username/repository.git', branch: 'master'
            }
        }

        stage('Integration Tests') {
            steps {
                // Run integration tests
                sh 'pytest tests/integration'
            }
        }

        stage('Dependency Check') {
            steps {
                // Perform dependency check with --noupdate parameter
                sh 'dependency-check --project "WebApp" --scan . --noupdate'
            }
        }

        stage('UI Testing') {
            steps {
                // Run UI tests using a tool like Selenium or Cypress

