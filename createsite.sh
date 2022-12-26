#!/bin/bash
# createsite.sh

set -e   #exit on most errors

##variables
wordpress_image=${1:-christianbueno1/wordpress:603-php80-8080}
pod_name=${2:-site}
database_image=${3:-mariadb:10.7.6-focal}
wordpress_port=${4:-8080}
mariadb_port=${5:-3306}
user=chris
#password=maGazine1!ec
password=Ecuadormipais1_
database_name=wordpress_db
#use your directories name
database_volume=var-lib-mysql
wordpress_volume=var-www-html
#
database_container_name=mariadb-${pod_name}
wordpress_container_name=wordpress-${pod_name}
##

echo "Creating the pod"
podman pod create --name ${pod_name} --infra --publish ${wordpress_port}:${wordpress_port} --publish ${mariadb_port}:${mariadb_port} --network bridge

echo "Creating the mariadb container"
podman run --pod ${pod_name} --name ${database_container_name} \
-e MARIADB_USER=${user} \
-e MARIADB_PASSWORD=${password} \
-e MARIADB_DATABASE=${database_name} \
-e MARIADB_ROOT_PASSWORD=${password} \
--volume ./${database_volume}:/var/lib/mysql:Z \
-d ${database_image}

echo "Creating the wordpress container"
podman run --pod ${pod_name} --name ${wordpress_container_name} \
-e WORDPRESS_DB_HOST=${database_container_name}:3306 \
-e WORDPRESS_DB_USER=${user} \
-e WORDPRESS_DB_PASSWORD=${password} \
-e WORDPRESS_DB_NAME=${database_name} \
--volume ./${wordpress_volume}:/var/www/html:Z \
-d ${wordpress_image}

#export PODMAN_USERNS=keep-id
#
#run the script
#
#./createsite.sh <wordpress_image> <pod_name> <database_image> <wordpress_port> <mariadb_port>
#./createsite.sh wordpress:611-php80-apache-8080 site mariadb:10.6.11-focal 8080 3306
#use default values last 3 parameters
#./createsite.sh christianbueno1/wordpress:602-8080 blog
#use the default wordpress_image=christianbueno1/wordpress:603-php80-8080 in the first argument and empty for the next 2 parameters.
#./createsite.sh "" podman-blog
#use the default wordpress_image, pod_name, database_image, port arguments
#./createsite.sh
