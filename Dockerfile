ARG UBUNTU_VERSION=22.04

####################################
# Temporary image for building Duc #
####################################

FROM ubuntu:${UBUNTU_VERSION} AS build

ARG DUC_VERSION=1.4.5

RUN apt-get update -qq \
 && apt-get install -qq --no-install-recommends \
        build-essential \
        checkinstall \
        libcairo2-dev \
        libncursesw5-dev \
        libpango1.0-dev \
        libtokyocabinet-dev \
        pkg-config \
        wget \
        git \
 && rm -rf /var/lib/apt/lists/*

ADD https://github.com/zevv/duc/releases/download/${DUC_VERSION}/duc-${DUC_VERSION}.tar.gz .

COPY *.patch .

RUN tar xzf duc-${DUC_VERSION}.tar.gz \
 && cd duc-${DUC_VERSION} \
 && git apply ../add-db-to-url.patch \
 && git apply ../show-html-on-error.patch \
 && ./configure \
 && make \
 && checkinstall --install=no --default \
 && cp duc_${DUC_VERSION}-*.deb /duc.deb

###############################
# Final image for running Duc #
###############################

FROM ubuntu:${UBUNTU_VERSION}

ARG BUILD_DATE
ARG VCS_REF
LABEL maintainer="George Ruinelli <caco3@ruinelli.ch>" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/caco3/duc-service.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

COPY --from=build /duc.deb /

RUN dpkg -i /duc.deb \
 && rm /duc.deb

RUN apt-get update -qq \
 && apt-get install -qq --no-install-recommends \
        cron \
        fcgiwrap \
        libcairo2 \
        libpango-1.0 \
        libpangocairo-1.0-0 \
        libtokyocabinet9 \
        nginx \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/www/html/*

# storage locaction for the database
RUN mkdir -p /database
# mount point for directories to index
RUN mkdir -p /scan

COPY app/nginx.conf /etc/nginx/nginx.conf
COPY app/ducrc /etc/ducrc

COPY app/*.cgi /var/www/html/
COPY app/*.png /var/www/html/
COPY app/*.ico /var/www/html/
COPY app/*.htm /var/www/html/
COPY app/*.css /var/www/html/
COPY app/log.cgi /var/www/html/log.cgi

COPY app/startup.sh /startup.sh
COPY app/scan.sh /scan.sh
COPY app/manual_scan.sh /manual_scan.sh

# Default schedule: everyday at midnight
ENV SCHEDULE 0 0 * * *

EXPOSE 80

STOPSIGNAL SIGTERM

CMD /startup.sh
