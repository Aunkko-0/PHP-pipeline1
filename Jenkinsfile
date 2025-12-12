pipeline {
    agent any

    environment {
        // !!! สำคัญ: ต้องมั่นใจว่า ID นี้เก็บ Username Github และ Password เป็น PAT Token !!!
        CR_CREDENTIALS_ID = 'webhook' 
        
        // ชื่อ Image ตามโครงสร้าง: ghcr.io/<github-username>/<package-name>
        FULL_IMAGE_NAME = 'ghcr.io/aunkko-0/php-project'
    }

    stages {
        // --- 1. Login ---
        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: CR_CREDENTIALS_ID, usernameVariable: 'GH_USER', passwordVariable: 'GH_TOKEN')]) {
                         """
                            # สั่งให้หยุดทันทีถ้ามี Error
                            \$ErrorActionPreference = 'Stop'
                            
                            Write-Host "Logging in to GHCR..."
                            # ใช้ Write-Output ส่ง Token ผ่าน Pipe เพื่อความแม่นยำ
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
                        Write-Host "Building Image: ${FULL_IMAGE_NAME}"
                        
                        # Build Image จาก Dockerfile ที่เราสร้าง
                        # ติด Tag 2 แบบ: เลข Build (เพื่อย้อนหลัง) และ latest (ตัวล่าสุด)
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
                        
                        # Push ขึ้น Server
                        docker push ${FULL_IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${FULL_IMAGE_NAME}:latest
                    """
                }
            }
        }
    }
    
    // (Optional) ล้างขยะหลังทำเสร็จ
    post {
        always {
            script {
                powershell """
                    Write-Host "Cleaning up local images..."
                    # ลบ Image ในเครื่อง Jenkins เพื่อไม่ให้หนักเครื่อง (แต่บน Server Github ยังอยู่)
                    docker rmi ${FULL_IMAGE_NAME}:${BUILD_NUMBER} -f
                    docker rmi ${FULL_IMAGE_NAME}:latest -f
                """
            }
        }
    }
}