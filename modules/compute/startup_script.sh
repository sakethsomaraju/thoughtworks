#!/bin/bash

sudo apt-get update -y && sudo apt-get install -y apache2 mariadb-server php php-mysql libapache2-mod-php php-xml php-mbstring php-intl jq

sudo systemctl start apache2
sudo systemctl enable apache2
cd ~
wget https://releases.wikimedia.org/mediawiki/1.41/mediawiki-1.41.1.tar.gz
# Download the GPG signature for the tarball and verify the tarball's integrity:
wget https://releases.wikimedia.org/mediawiki/1.41/mediawiki-1.41.1.tar.gz.sig
gpg --verify mediawiki-1.41.1.tar.gz.sig mediawiki-1.41.1.tar.gz
sudo tar -zxf ~/mediawiki-1.41.1.tar.gz
cd mediawiki-1.41.1
sudo mkdir -p /var/www/html/wiki
cp -r . /var/www/html/wiki
cd /var/www/html/wiki
sudo chown -R apache:apache /var/www/html/mediawiki
sudo sed 's/MyISAM/innodb/g' maintenance/tables-generated.sql

name=$(curl http://metadata.google.internal/computeMetadata/v1/instance/name -H "Metadata-Flavor: Google")
zone=$(curl http://metadata.google.internal/computeMetadata/v1/instance/zone -H "Metadata-Flavor: Google")
export DATABASE_IP=$(gcloud compute instances describe $name --flatten="metadata[]" --zone=$zone --format="json" | jq .[0].items[3].value)
export LOAD_BALANCER_IP=$(gcloud compute instances describe $name --flatten="metadata[]" --zone=$zone --format="json" | jq .[0].items[2].value)
export DATABASE_IP=$(echo $DATABASE_IP | sed 's/"//g')
export LOAD_BALANCER_IP=$(echo $LOAD_BALANCER_IP | sed 's/"//g')

for i in 1 2;
do
    sudo php maintenance/install.php --dbname=wikidb --dbserver="$DATABASE_IP" --dbuser=root --dbpass=root --server="http://$LOAD_BALANCER_IP" --scriptpath=/wiki --lang=en --pass="sakconfigpassw" "playground" "admin"
    sleep 5
done
