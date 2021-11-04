docker run --rm --name letsencrypt \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/lib/letsencrypt:/var/lib/letsencrypt \
  certbot/certbot certonly -n \
  -m $1 \
   --agree-tos \
  -d $2 \
  -d *.$2 \
  --webroot --webroot-path /var/lib/letsencrypt/webroot/

# Now enable/create the HTTPS nginx VHost
#docker exec nginx sed -r 's,^(\s*)#(include /etc/nginx/nginx-https_server.conf;)$,\1\2,' /etc/nginx/nginx.conf

# Reload Nginx Container
#docker kill -s HUP webserver