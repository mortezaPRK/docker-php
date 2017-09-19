ARG NGINX_VERSION

FROM nginx:$NGINX_VERSION

COPY usermod /usermod
RUN chmod +x /usermod && \
    /usermod xfs xfs 32 32 33 33 && \
    /usermod nginx nginx 33 33 100 101 && \
    rm /usermod
