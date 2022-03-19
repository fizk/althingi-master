#!/bin/bash


#
# This script is expecting the system to live in `/var/app`
# 	and the Domain to be `loggjafarthing.einarvalur.co`.
# 	If this is not the case, then you need to change these two values.
#
# This script is also expecting that a domain has already been registered with letsencrypt,
#	the purpose of this script is only to renew. If that's not the case, you need to 
#	run this first:
#
# ```
# sudo docker run -it --rm --name certbot \
#             -v "/etc/letsencrypt:/etc/letsencrypt" \
#             -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
#             certbot/certbot certonly
#```
#
# This script will stop the Client, (letsencrypt needs the 80 port).
# Then it will renew the certificate.
# Next it will copy the needed .pem files to the system's project directory
#	change the read permissions where needed
# And finally start the Client again, allowing it to mount the new .pem files

docker stop althingi-client

sudo docker run -it --rm --name certbot \
	-v "/etc/letsencrypt:/etc/letsencrypt" \
	-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
	certbot/certbot renew

cp /etc/letsencrypt/live/loggjafarthing.einarvalur.co/fullchain.pem /var/app/fullchain.pem
cp /etc/letsencrypt/live/loggjafarthing.einarvalur.co/privkey.pem /var/app/privkey.pem
cp /etc/letsencrypt/options-ssl-apache.conf /var/app/options-ssl-apache.conf

chmod a+r /var/app/privkey.pem

cd /var/app

docker-compose up -d client

date
