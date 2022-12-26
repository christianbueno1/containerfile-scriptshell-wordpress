#Containerfile

ARG wordpress_image=wordpress:6.0.3-php8.0-apache
FROM $wordpress_image
ARG port=8080
LABEL maintainer="Christian Bueno <chmabuen@espol.edu.ec>" 
#add port
RUN cd /etc/apache2/; \
sed -i "/Listen 80/aListen $port" ports.conf; \
cd /etc/apache2/sites-available/; \
sed -i "s/:80/*:*/" 000-default.conf
EXPOSE $port
CMD ["apache2-foreground"]
# podman build --build-arg port=<port> --build-arg wordpress_image=<wordpress_image> -t <wordpress_name_and_tag> -f Containerfile
# podman build --build-arg port=8082 --build-arg wordpress_image=wordpress:6.0.2-php7.4-apache -t christianbueno1/wordpress:602-8082 -f Containerfile
# podman build -t christianbueno1/wordpress:602-8080 -f Containerfile
# podman build -t <new_image_name:version> -f Containerfile

