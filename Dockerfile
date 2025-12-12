# ใช้ PHP 8.2 พร้อม Apache Web Server
FROM php:8.2-apache

# เปิดใช้งาน mod_rewrite (เผื่อต้องใช้ .htaccess)
RUN a2enmod rewrite

# ติดตั้ง Extension พื้นฐานที่ PHP มักต้องใช้ (เช่น เชื่อม Database)
RUN docker-php-ext-install mysqli pdo pdo_mysql

# กำหนด Working Directory
WORKDIR /var/www/html
