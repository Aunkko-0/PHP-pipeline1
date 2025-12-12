pipeline {
    agent any

    environment {
        // ID ของ Credential (ต้องมี user/token)
        CR_CREDENTIALS_ID = 'webhook' 
        
        // ชื่อ Image
        FULL_IMAGE_NAME = 'ghcr.io/aunkko-0/php-project'
    }

    stages {
        // --- 1. Login ---
        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: CR_CREDENTIALS_ID, usernameVariable: 'GH_USER', passwordVariable: 'GH_TOKEN')]) {
                        if (isUnix()) {
                            // --- โซน Linux/Mac (Shell) ---
                            sh 'echo $GH_TOKEN | docker login ghcr.io -u $GH_USER --password-stdin'
                        } else {
                            // --- โซน Windows (PowerShell) ---
                            powershell """
                                \$ErrorActionPreference = 'Stop'
                                Write-Output \$env:GH_TOKEN | docker login ghcr.io -u \$env:GH_USER --password-stdin
                            """
                        }
                    }
                }
            }
        }

        // --- 2. Build ---
        stage('Docker Build') {
            steps {
                script {
                    def buildCmd = "docker build -t ${FULL_IMAGE_NAME}:${BUILD_NUMBER} -t ${FULL_IMAGE_NAME}:latest ."
                    
                    if (isUnix()) {
                        sh buildCmd
                    } else {
                        powershell buildCmd
                    }
                }
            }
        }

        // --- 3. Push ---
        stage('Docker Push') {
            steps {
                script {
                    def pushCmd = """
                        docker push ${FULL_IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${FULL_IMAGE_NAME}:latest
                    """
                    
                    if (isUnix()) {
                        sh pushCmd
                    } else {
                        powershell pushCmd
                    }
                }
            }
        }
    }
    
    // --- (Optional) Clean up ---
    post {
        always {
            script {
                def cleanCmd = "docker rmi ${FULL_IMAGE_NAME}:${BUILD_NUMBER}"
                // ถ้าอยากลบให้เอา comment ออก
                // if (isUnix()) { sh cleanCmd } else { powershell cleanCmd }
            }
        }
    }
}