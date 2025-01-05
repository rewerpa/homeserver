FROM nginx:1.27.3-alpine AS module-build
RUN apk add build-base libxslt-dev pcre-dev zlib-dev openssl-dev
RUN wget https://nginx.org/download/nginx-1.27.3.tar.gz
# RUN wget https://github.com/arut/nginx-dav-ext-module/archive/refs/tags/v3.0.0.tar.gz -O nginx-dav-ext-module.tar.gz
RUN wget https://github.com/mid1221213/nginx-dav-ext-module/archive/refs/tags/v4.0.1.tar.gz -O nginx-dav-ext-module.tar.gz
RUN tar -zxvf nginx-1.27.3.tar.gz
RUN tar -zxvf nginx-dav-ext-module.tar.gz
RUN mv nginx-dav-ext-module-4.0.1 nginx-dav-ext-module
WORKDIR /nginx-1.27.3
RUN ./configure --with-compat --add-dynamic-module=../nginx-dav-ext-module
RUN make modules

FROM nginx:1.27.3-alpine
COPY --from=module-build nginx-1.27.3/objs/ngx_http_dav_ext_module.so /usr/lib/nginx/modules
RUN mkdir -p /var/www/html/dav
RUN chown -R nginx:nginx /var/www/html/dav
