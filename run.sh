mv /usr/src/app/csuf/collected_static_files /var/www/static/
rm /etc/nginx/sites-enabled/default
# Create soft link 
ln -s /usr/src/app/csuf/csuf_nginx.conf /etc/nginx/sites-enabled/

# Start nginx
/etc/init.d/nginx start
# Start uwsgi
uwsgi --ini /usr/src/app/csuf/csuf_uwsgi.ini