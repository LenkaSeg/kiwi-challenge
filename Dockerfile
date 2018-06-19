FROM nginx:alpine

WORKDIR /kiwi

#RUN apt update -y && \
#    apt install python-flask -y && \
RUN set -x  \
    && addgroup -g 82 -S kiwi  \
    && adduser -u 82 -D -S -G kiwi kiwi && exit 0 ; exit 1

COPY site.html /usr/share/nginx/html

COPY default.conf /etc/nginx/conf.d/default.conf


RUN chown kiwi -R /kiwi

EXPOSE 5000

VOLUME /etc/nginx/certs

ENTRYPOINT ["nginx", "-g", "daemon off;"]

