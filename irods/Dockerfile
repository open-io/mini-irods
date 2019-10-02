FROM ubuntu:16.04

ARG LSB_RELEASE=xenial

EXPOSE  1247
EXPOSE 20000:2099

RUN apt-get update && \
    apt-get install -y wget apt-transport-https ca-certificates awscli && \
    apt-get upgrade -y

RUN \
    wget -qO - https://packages.irods.org/irods-signing-key.asc |  apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $LSB_RELEASE main" |  tee /etc/apt/sources.list.d/renci-irods.list && \
    apt-get update && \
    apt-get install -y irods-server irods-database-plugin-postgres irods-resource-plugin-s3

RUN useradd -ms /bin/bash alice && \
    useradd -ms /bin/bash bobby

COPY create.sql config.json docker-entrypoint.sh start.sh login-irods.sh test.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/start.sh"]
