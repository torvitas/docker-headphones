FROM debian:8
MAINTAINER Sascha Marcel Schmidt <docker@saschaschmidt.net>

RUN groupadd -r -g 666 headphones && \
    useradd -r -u 666 -g 666 -d /headphones headphones

RUN apt-get -q update \
    && apt-get install -qy git \
    && git clone https://github.com/rembo10/headphones.git headphones \
    && chown -R headphones: headphones \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

USER headphones
WORKDIR ["/headphones"]

COPY run.sh /

CMD ["/bin/bash", "/run.sh"]
