FROM nginx:1.9
MAINTAINER Carles Amigó, fr3nd@fr3nd.net

RUN apt-get update && apt-get install -y \
      git \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*

ENV NGINX_AUTOINDEX_HASH 89f703f11ad3f28871e89015aeba6c2f7d7772f9

WORKDIR /usr/src
COPY fix_api.patch /usr/src/fix_api.patch
RUN git clone https://github.com/kstep/nginx-autoindex-js.git && \
    cd nginx-autoindex-js && \
    git checkout ${NGINX_AUTOINDEX_HASH} && \
    rm -rf .git && \
    patch -p1 < ../fix_api.patch

RUN rm -rf /usr/share/nginx/html
RUN ln -s /usr/src/nginx-autoindex-js /usr/share/nginx/html
RUN mkdir -p /usr/share/nginx/html/files
COPY nginx.conf /etc/nginx/nginx.conf
COPY config.json /usr/share/nginx/html/config.json
