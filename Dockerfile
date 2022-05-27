FROM --platform=linux/amd64 php:7-cli-bullseye

ARG DEBIAN_FRONTEND=noninteractive

ARG jdk='openjdk-11-jdk-headless'
ARG jvm='/usr/lib/jvm/java-11-openjdk-amd64'

# needed for openjdk-11-jdk-headless
RUN mkdir -p /usr/share/man/man1

## dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends ${jdk} unzip libxml-commons-resolver1.1-java

ARG version='11.3'

## fetch
RUN curl https://www.saxonica.com/download/libsaxon-HEC-setup64-v${version}.zip --output /tmp/saxon.zip
RUN unzip /tmp/saxon.zip -d /opt/saxon

## install
WORKDIR /opt/saxon/libsaxon-HEC-${version}
RUN cp libsaxonhec.so /usr/lib/
RUN cp -r rt /usr/lib/
RUN cp -r saxon-data /usr/lib/

ENV SAXONC_HOME=/usr/lib

## build
WORKDIR /opt/saxon/libsaxon-HEC-${version}/Saxon.C.API
RUN phpize
RUN ./configure --enable-saxon
RUN make
RUN make install
RUN echo 'extension=saxon.so' > "$PHP_INI_DIR/conf.d/20-saxon.ini"
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /opt
CMD ["php", "example.php"]

