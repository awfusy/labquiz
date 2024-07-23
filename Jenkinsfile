pipeline {
    agent any

    environment {
        PYTHON_VERSION = '3.9.13' // Specify the Python version you want to install
        PYTHON_DIR = "${env.WORKSPACE}/python" // Directory to install Python
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git url: 'https://github.com/awfusy/labquiz.git', branch: 'main'
            }
        }

        stage('Setup Python') {
            steps {
                // Install Python if not already installed
                sh '''
                    if [ ! -d "${PYTHON_DIR}" ]; then
                        echo "Python not found. Installing Python ${PYTHON_VERSION}..."
                        wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
                        tar -xzf Python-${PYTHON_VERSION}.tgz
                        cd Python-${PYTHON_VERSION}
                        ./configure --prefix=${PYTHON_DIR}
                        make
                        make install
                        cd ..
                    else
                        echo "Python already installed."
                    fi
                '''
            }
        }

        stage('Setup Environment') {
            steps {
                // Set up the environment and install dependencies
                sh '''
                    export PATH=${PYTHON_DIR}/bin:$PATH
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
