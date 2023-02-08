# According to Saxonica's website, they tested with 8.1.11
# https://www.saxonica.com/saxon-c/documentation12/index.html#!starting/installingphp
FROM --platform=linux/amd64 fedora:37

ARG SAXON_VER='12.0'

## dependencies
RUN dnf install -y php-cli php-devel unzip xml-commons-resolver xml-commons-apis

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
RUN echo 'extension=saxon' > /etc/php.d/20-saxon.ini

WORKDIR /code
CMD ["php", "example.php"]

