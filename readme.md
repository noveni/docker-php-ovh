# PHP image for docker

Run this command :

``docker run -d -p 80:80 --name my-apache-php-app -v "$PWD":/var/www/html noveni/php-ovh:5.6-apache``