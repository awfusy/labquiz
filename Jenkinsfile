pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git url: 'https://github.com/awfusy/labquiz.git', branch: 'main'
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
                // Example with Selenium:
                sh 'pytest tests/ui'
            }
        }
    }

    post {
        always {
            // Archive test reports
            junit 'tests/reports/**/*.xml'
            // Archive any other artifacts
            archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
        }
        success {
            // Actions to take on successful completion of the pipeline
            echo 'Pipeline completed successfully.'
        }
        failure {
            // Actions to take on pipeline failure
            echo 'Pipeline failed.'
        }
    }
}
