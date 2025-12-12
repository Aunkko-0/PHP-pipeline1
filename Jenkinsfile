pipeline {
    agent any

    environment {
        // ID ของ Credential
        CR_CREDENTIALS_ID = 'github' 
        
        // ชื่อ Image (ตัวพิมพ์เล็ก)
        FULL_IMAGE_NAME = 'ghcr.io/aunkko-0/php-project'
    }

    stages {
        // --- 1. Login ---
        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: CR_CREDENTIALS_ID, usernameVariable: 'USER', passwordVariable: 'TOKEN')]) {
                        powershell """
                            Write-Host "Logging in to GHCR..."
                            echo \$env:TOKEN | docker login ghcr.io -u \$env:USER --password-stdin
                        """
                    }
                }
            }
        }

        // --- 2. Build (ติด Tag latest ด้วย) ---
        stage('Docker Build') {
            steps {
                script {
                    powershell """
                        Write-Host "Building Image..."
                        # Build รอบเดียว ได้ 2 Tags (เลข Build และ latest)
                        docker build -t ${FULL_IMAGE_NAME}:${BUILD_NUMBER} -t ${FULL_IMAGE_NAME}:latest .
                    """
                }
            }
        }

        // --- 3. Push ---
        stage('Docker Push') {
            steps {
                script {
                    powershell """
                        Write-Host "Pushing to GitHub Packages..."
                        # Push ทั้งตัวเลขและ latest
                        docker push ${FULL_IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${FULL_IMAGE_NAME}:latest
                    """
                }
            }
        }
    }
}