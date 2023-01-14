FROM nginx:stable
############

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

# change welcome page 
RUN sed -i.bak -e 's/Welcome/Welcome HONGQI/' /usr/share/nginx/html/index.html
#COPY index.html /usr/share/nginx/html/index.html
# users are not allowed to listen on priviliged ports
RUN sed -i.bak -e 's/listen\( *\)80;/listen 8081;/' -e 's/listen\(.*\)80;//' /etc/nginx/conf.d/default.conf
EXPOSE 8081

# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
