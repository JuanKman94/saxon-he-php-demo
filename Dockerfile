# According to Saxonica's website, they tested with 8.1.11
# https://www.saxonica.com/saxon-c/documentation12/index.html#!starting/installingphp
FROM --platform=linux/amd64 php:8.1.11-cli-bullseye

ARG DEBIAN_FRONTEND=noninteractive

ARG jdk='openjdk-11-jdk-headless'
ARG jvm='/usr/lib/jvm/java-11-openjdk-amd64'
ARG SAXON_VER='12.0'

# needed for openjdk-11-jdk-headless
RUN mkdir -p /usr/share/man/man1

## dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends ${jdk} unzip libxml-commons-resolver1.1-java

## fetch
RUN curl https://www.saxonica.com/download/libsaxon-HEC-linux-v${SAXON_VER}.zip --output /tmp/saxon.zip
RUN unzip /tmp/saxon.zip -d /opt/saxon
RUN rm /tmp/saxon.zip

## install
WORKDIR /opt/saxon/libsaxon-HEC-linux-v${SAXON_VER}
RUN cp libs/nix/libsaxon-hec-${SAXON_VER}.so /usr/lib/

## build
WORKDIR /opt/saxon/libsaxon-HEC-linux-v${SAXON_VER}/Saxon.C.API
RUN phpize
RUN ./configure --enable-saxon
# TODO: submit issue to Saxonica tracker: https://saxonica.plan.io/issues
RUN sed -i 's|setRelocate|setRelocatable|g' php8_*.c*
RUN make
RUN make install
RUN echo 'extension=saxon' > "$PHP_INI_DIR/conf.d/20-saxon.ini"
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /code
CMD ["php", "example.php"]

