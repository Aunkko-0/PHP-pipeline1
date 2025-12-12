pipeline {
    agent any

    environment {
        CR_CREDENTIALS_ID = 'webhook' 
        FULL_IMAGE_NAME = 'ghcr.io/aunkko-0/php-project'
    }

    stages {
        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: CR_CREDENTIALS_ID, usernameVariable: 'GH_USER', passwordVariable: 'GH_TOKEN')]) {
                        // ใช้ bat ต้องใช้ syntax ของ cmd.exe
                        bat """
                            @echo off
                            echo Checking Credentials...
                            echo Username from Jenkins: %GH_USER%
                            
                            echo Logging in to GHCR...
                            REM ส่ง Password ผ่าน Pipe ใน cmd ใช้ echo ธรรมดา
                            echo %GH_TOKEN% | docker login ghcr.io -u %GH_USER% --password-stdin
                        """
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    bat """
                        echo Building Image...
                        docker build -t ${FULL_IMAGE_NAME}:${BUILD_NUMBER} -t ${FULL_IMAGE_NAME}:latest .
                    """
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    bat """
                        echo Pushing to GitHub Packages...
                        docker push ${FULL_IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${FULL_IMAGE_NAME}:latest
                    """
                }
            }
        }
    }
}