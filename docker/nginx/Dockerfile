FROM nginx:alpine
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www

CMD ["nginx", "-g", "daemon off;"]