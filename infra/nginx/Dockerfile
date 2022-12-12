FROM nginx:1.23-alpine

RUN apk add --no-cache openssl

COPY ssl/bookmeCA.pem /etc/ssl/private/bookmeCA.pem
COPY ssl/bookmeCA.key /etc/ssl/private/bookmeCA.key
COPY ssl/local.com.ext /etc/ssl/private/local.com.ext

RUN openssl genrsa -out /etc/ssl/private/local.com.key 2048
RUN openssl req -new -key /etc/ssl/private/local.com.key -out /etc/ssl/private/local.com.csr -subj "/C=FR/CN=local.com"
RUN openssl x509 -req -in /etc/ssl/private/local.com.csr -CA /etc/ssl/private/bookmeCA.pem -CAkey /etc/ssl/private/bookmeCA.key -CAcreateserial -out /etc/ssl/private/local.com.crt -days 365 -sha256 -extfile /etc/ssl/private/local.com.ext -passin pass:'astromnia'

EXPOSE 80
EXPOSE 443
