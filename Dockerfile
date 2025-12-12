# ใช้ Base Image เป็น PHP 8.2 พร้อม Apache
FROM php:8.2-apache

# กำหนด Working Directory
WORKDIR /var/www/html

# Copy ไฟล์ทั้งหมดจากเครื่องเราเข้าไปใน Container
COPY . /var/www/html/

# เปิด Port 80 (มาตรฐาน Web)
EXPOSE 80

# (Optional) ถ้ามีการใช้ rewrite module ของ apache ให้เปิดบรรทัดนี้
# RUN a2enmod rewrite