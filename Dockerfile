FROM nginx:1.19-perl
ADD default.conf /etc/nginx/nginx.conf.d/
ADD /dist/test-angular /usr/share/nginx/html/
USER root
RUN addgroup --system --gid 102 credicoregroup \
    && adduser --system --ingroup credicoregroup --home /usr/share/nginx/html --shell /sbin/nologin --no-create-home --uid 102 credicoreuser \
    && chown -R credicoreuser:credicoregroup /var/cache/nginx /var/run \
    && chmod -R 770 /var/cache/nginx /var/run \
    && touch /var/run/nginx.pid \
    && chown credicoreuser:credicoregroup /var/run/nginx.pid 
RUN chown -Rf credicoreuser:credicoregroup /var/run/
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcap2-bin \
    && rm -rf /var/lib/apt/lists/* 
RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx
USER credicoreuser