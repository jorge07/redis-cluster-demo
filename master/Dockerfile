FROM redis:3.2.8-alpine

ARG PORT=6379

ADD rootfs /

RUN sed -i -e "s/6379/$PORT/g" /usr/local/redis/redis.conf

WORKDIR /redis-master-data

VOLUME /redis-master-data

CMD [ "redis-server", "/usr/local/redis/redis.conf" ]
