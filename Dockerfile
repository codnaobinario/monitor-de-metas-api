FROM navidonskis/nginx-php5.6

ENV DBDRIVE='mysql'
ENV DBHOST='127.0.0.1'
ENV DBPORT='3306'
ENV DBNAME='pdm_api'
ENV DBUSER='wp'
ENV DBPASS='wp'
ENV DBPREFIX=''

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install curl php5-cli git -y -o Dpkg::Options::="--force-confold"

RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.20

RUN git clone https://github.com/mbnunes/monitor-de-metas-api.git

WORKDIR "/monitor-de-metas-api"

RUN composer clear-cache
RUN composer self-update --snapshot
RUN composer install -vvv --ansi --profile

COPY ./entrypoint/entrypoint.sh .

EXPOSE 80

ENTRYPOINT ["bash", "entrypoint.sh"]