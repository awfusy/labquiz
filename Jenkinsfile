pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/awfusy/labquiz.git'
            }
        }

        stage('Prepare Scripts') {
            steps {
                sh 'git update-index --chmod=+x jenkins/scripts/deploy.sh'
                sh 'git update-index --chmod=+x jenkins/scripts/kill.sh'
            }
        }

        stage('Start Docker Compose') {
            steps {
                sh 'docker-compose up -d'
            }
        }

        stage('Install Dependencies') {
            agent {
                docker {
                    image 'python:latest'
                    args '-u root'
                }
            }
            steps {
                sh '''
                    docker-compose exec web pip install pytest pytest-cov selenium webdriver-manager
                '''
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'mkdir -p logs'
                script {
                    try {
                        sh 'docker-compose exec web pytest --junitxml=logs/unitreport.xml'
                    } catch (Exception e) {
                        echo "pytest failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
            post {
                always {
                    junit testResults: 'logs/unitreport.xml', allowEmptyResults: true
                }
            }
        }

        stage('Integration UI Test') {
            parallel {
                stage('Headless Browser Test') {
                    steps {
                        sh '''
                            docker-compose exec web pip install selenium webdriver-manager pytest
                            docker-compose exec web apt-get update
                            docker-compose exec web apt-get install -y wget unzip --fix-missing
                            docker-compose exec web wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                            docker-compose exec web apt install -y ./google-chrome-stable_current_amd64.deb
                            docker-compose exec web wget https://chromedriver.storage.googleapis.com/$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
                            docker-compose exec web unzip -o chromedriver_linux64.zip
                            docker-compose exec web mv chromedriver /usr/local/bin/
                        '''
                        sh 'mkdir -p logs'
                        script {
                            try {
                                sh 'docker-compose exec web pytest test_app.py --junitxml=logs/integration_test_results.xml'
                            } catch (Exception e) {
                                echo "Integration tests failed: ${e.message}"
                                currentBuild.result = 'FAILURE'
                            }
                        }
                    }
                    post {
                        always {
                            junit 'logs/integration_test_results.xml'
                        }
                    }
                }
                stage('Deploy') {
                    steps {
                        sh './jenkins/scripts/deploy.sh'
                        input message: 'Finished using the web site? (Click "Proceed" to continue)'
                        sh './jenkins/scripts/kill_integration.sh'
                    }
                }
            }
        }

        stage('Code Quality Check via SonarQube') {
            steps {
                script {
                    def scannerHome = tool 'SonarQube_Flask'
                    withSonarQubeEnv('SonarQube_Flask') {
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=FlaskDemo -Dsonar.sources=."
                    }
                }
            }
        }

        stage('Stop Docker Compose') {
            steps {
                sh 'docker-compose down'
            }
        }
    }

    post {
        always {
            junit testResults: 'logs/**/*.xml', allowEmptyResults: true
            recordIssues enabledForFailure: true, tool: sonarQube()
        }
    }
}
