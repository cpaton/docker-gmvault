FROM alpine:latest

ENV TZ=Europe/London \
    GMVAULT_EMAIL_ADDRESS="test@example.com" \
    GMVAULT_FULL_SYNC_SCHEDULE="30 1 * * 0" \
    GMVAULT_QUICK_SYNC_SCHEDULE="30 1 * * 1-6" \
    CRONTAB="/var/spool/cron/crontabs/gmvault" \
    GMVAULT_UID=1024 \
    GMVAULT_GID=100

RUN mkdir /app \
    && mkdir /data \
    && mkdir /data/home \
    && mkdir /data/db
WORKDIR /app

VOLUME [ "/data", "/log" ]

RUN apk update && \
    apk add bash \
            ca-certificates \
            py-pip \
            python \
		    shadow \
            su-exec \
            tzdata \
    && pip install --upgrade pip \
	&& pip install gmvault==1.9.1 \
    && rm -rf /var/cache/apk/* \
    && addgroup -g 9000 gmvault \
    && adduser -h /data/home -D -u 9000 -s "/bin/bash" -G "gmvault" gmvault

COPY *.sh /app/  
RUN chmod u+x,g+x,o+x /app/*.sh  
ENTRYPOINT [ "/app/entrypoint.sh" ]