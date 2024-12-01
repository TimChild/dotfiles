#!/bin/bash
# This script uses a standalone docker instance to extend the SSL certificates on an existing webserver
# The existing webserver is expected to match the basic reflex webserver setup I typically use
# i.e. 
#   $webserver_dir/ssl_certs/letsencrypt
#   $webserver_dir/certbot/www
#   $webserver_dir/logs/certbot

# Extend the SSL certificates

webserver_dir=$1
domain_list=$2

# Check cert_path exists
if [ ! -d "$webserver_dir" ]; then
    echo "webserver_dir $webserver_dir does not exist"
    exit 1
fi

# Check domain_list is not empty
if [ -z "$domain_list" ]; then
    echo "Domain list ($domain_list) is empty"
    exit 1
fi

echo "Extending SSL certificates..."
echo "Full new domain list $domain_list"
echo "Note: A webserver must already be running for this to work..."

docker run --rm\
    -v "$webserver_dir"/ssl_certs/letsencrypt:/etc/letsencrypt\
    -v "$webserver_dir"/certbot/www:/var/www/certbot\
    -v "$webserver_dir"/logs/certbot:/var/log/letsencrypt\
    certbot/certbot certonly\
    --webroot --webroot-path=/var/www/certbot --expand -d "$domain_list"

echo "Successfully extended SSL certificates"
 
