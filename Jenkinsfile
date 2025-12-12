pipeline {
    agent any

    environment {
        // !!! ตรวจสอบว่า ID นี้เก็บ Username และ PAT Token ที่ถูกต้อง !!!
        CR_CREDENTIALS_ID = 'webhook' 
        
        // ชื่อ Image (ต้องเป็นตัวพิมพ์เล็กทั้งหมดตามกฎของ Docker)
        FULL_IMAGE_NAME = 'ghcr.io/aunkko-0/php-project'
    }

    stages {
        // --- 1. Login ---
        stage('Docker Login') {
            steps {
                script {
                    // ดึง Username และ Password มาเก็บในตัวแปร GH_USER และ GH_TOKEN
                    withCredentials([usernamePassword(credentialsId: CR_CREDENTIALS_ID, usernameVariable: 'GH_USER', passwordVariable: 'GH_TOKEN')]) {
                        powershell """
                            \$ErrorActionPreference = 'Stop'
                            Write-Host "Logging in to GHCR..."
                            
                            # ใช้ Write-Output ส่ง Token ผ่าน Pipe เข้า stdin ของ docker login
                            # สังเกตการใช้ \\$ เพื่อ escape ให้เป็นตัวแปรของ PowerShell
                            Write-Output \$env:GH_TOKEN | docker login ghcr.io -u \$env:GH_USER --password-stdin
                        """
                    }
                }
            }
        }

        // --- 2. Build ---
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

        // --- 3. Push ---
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
    
    // (Optional) ล้าง Docker Image หลังทำเสร็จเพื่อไม่ให้รกเครื่อง
    post {
        always {
            script {
                powershell """
                    Write-Host "Cleaning up..."
                    # ลบ Image เพื่อประหยัดพื้นที่ (ถ้าต้องการ)
                    # docker rmi ${FULL_IMAGE_NAME}:${BUILD_NUMBER} -f
                    # docker rmi ${FULL_IMAGE_NAME}:latest -f
                """
            }
        }
    }
}