pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git url: 'https://github.com/awfusy/labquiz.git', branch: 'main'
            }
        }

        stage('Setup Environment') {
            steps {
                // Install necessary dependencies
                sh '''
                    python3 -m venv venv
                    source venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Migrations') {
            steps {
                // Apply Django migrations
                sh '''
                    source venv/bin/activate
                    python manage.py migrate
                '''
            }
        }

        stage('Integration Tests') {
            steps {
                // Run integration tests
                sh '''
                    source venv/bin/activate
                    pytest tests/integration
                '''
            }
        }

        stage('Dependency Check') {
            steps {
                // Perform dependency check with --noupdate parameter
                sh '''
                    source venv/bin/activate
                    dependency-check --project "WebApp" --scan . --noupdate
                '''
            }
        }

        stage('UI Testing') {
            steps {
                // Run UI tests using a tool like Selenium or Cypress
                sh '''
                    source venv/bin/activate
                    pytest tests/ui
                '''
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
