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
                    // เปลี่ยนชื่อตัวแปรเป็น GH_USER, GH_TOKEN เพื่อไม่ให้ชนกับ System Env
                    withCredentials([usernamePassword(credentialsId: CR_CREDENTIALS_ID, usernameVariable: 'GH_USER', passwordVariable: 'GH_TOKEN')]) {
                        powershell """
                            \$ErrorActionPreference = 'Stop'
                            
                            # Debug: เช็คว่า Jenkins อ่าน Username มาถูกไหม (Password จะถูกซ่อนเป็น ****)
                            Write-Host "Checking Credentials..."
                            Write-Host "Username from Jenkins: \$env:GH_USER"
                            
                            Write-Host "Logging in to GHCR..."
                            # ส่ง Token เข้า Login
                            Write-Output \$env:GH_TOKEN | docker login ghcr.io -u \$env:GH_USER --password-stdin
                        """
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    powershell """
                        \$ErrorActionPreference = 'Stop'
                        Write-Host "Building Image..."
                        docker build -t ${FULL_IMAGE_NAME}:${BUILD_NUMBER} -t ${FULL_IMAGE_NAME}:latest .
                    """
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    powershell """
                        \$ErrorActionPreference = 'Stop'
                        Write-Host "Pushing to GitHub Packages..."
                        docker push ${FULL_IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${FULL_IMAGE_NAME}:latest
                    """
                }
            }
        }
    }
}