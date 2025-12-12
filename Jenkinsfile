pipeline {
    agent any

    environment {
        // ID ที่คุณตั้งใน Jenkins (ตรวจสอบให้แน่ใจว่าชื่อนี้จริงหรือไม่ เช่น 'github', 'webhook' หรือ 'github-access-token')
        CR_CREDENTIALS_ID = 'webhook' 
        
        // **สำคัญ:** ชื่อ Image ต้องเป็นตัวพิมพ์เล็กทั้งหมด
        FULL_IMAGE_NAME = 'ghcr.io/aunkko-0/php-project'
    }

    stages {
        stage('Login & Build & Push') {
            steps {
                script {
                    // ดึง Username/Password มาจาก ID
                    withCredentials([usernamePassword(credentialsId: CR_CREDENTIALS_ID, usernameVariable: 'USER', passwordVariable: 'TOKEN')]) {
                        
                        // ใช้ powershell แทน sh
                        powershell """
                            # 1. Login เข้า GitHub Registry
                            # ใน PowerShell ใช้ $env:VAR เพื่อเรียกตัวแปร
                            echo \$env:TOKEN | docker login ghcr.io -u \$env:USER --password-stdin
                            
                            # 2. Build Image
                            docker build -t ${FULL_IMAGE_NAME}:${BUILD_NUMBER} .
                            
                            # 3. Push ขึ้น GitHub
                            docker push ${FULL_IMAGE_NAME}:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            // 4. Cleanup: ลบ Image ออกจากเครื่อง Jenkins
            // ใช้ powershell และตรวจสอบ logic การ error
            powershell """
                try {
                    docker rmi ${FULL_IMAGE_NAME}:${BUILD_NUMBER} -Force
                } catch {
                    Write-Host "Image not found or already removed."
                }
            """
        }
    }
}