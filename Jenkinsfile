pipeline {
    agent any

    environment {
        // ID ที่คุณตั้งใน Jenkins
        CR_CREDENTIALS_ID = 'github' 
        
        // ชื่อ Image เต็มๆ ที่คุณระบุมา
        FULL_IMAGE_NAME = 'ghcr.io/Aunkko-0/php-project'
    }

    stages {
        stage('Login & Build & Push') {
            steps {
                script {
                    // ดึง Username/Password มาจาก ID 'github'
                    withCredentials([usernamePassword(credentialsId: CR_CREDENTIALS_ID, usernameVariable: 'USER', passwordVariable: 'TOKEN')]) {
                        
                        // 1. Login เข้า GitHub Registry
                        sh "echo $TOKEN | docker login ghcr.io -u $USER --password-stdin"
                        
                        // 2. Build Image (ใช้เลข Build Number เป็น Tag)
                        sh "docker build -t ${FULL_IMAGE_NAME}:${BUILD_NUMBER} ."
                        
                        // 3. Push ขึ้น GitHub
                        sh "docker push ${FULL_IMAGE_NAME}:${BUILD_NUMBER}"
                    }
                }
            }
        }
    }

    post {
        always {
            // 4. Cleanup: ลบ Image ออกจากเครื่อง Jenkins ทันทีเพื่อประหยัดพื้นที่
            // (ใส่ || true กัน Error กรณี Build ไม่ผ่าน)
            sh "docker rmi ${FULL_IMAGE_NAME}:${BUILD_NUMBER} || true"
        }
    }
}