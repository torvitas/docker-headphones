FROM debian:8
MAINTAINER Sascha Marcel Schmidt <docker@saschaschmidt.net>

RUN groupadd -r -g 666 headphones && \
    useradd -r -u 666 -g 666 -d /headphones headphones

RUN apt-get -q update \
    && apt-get install -qy git python libav-tools shntool \
    && git clone https://github.com/rembo10/headphones.git headphones \
    && chown -R headphones: headphones \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

WORKDIR "/headphones"
VOLUME ["/datadir", "/download"]
EXPOSE 8181

COPY run.sh /
COPY headphones.ini /headphones/

CMD ["/bin/bash", "/run.sh"]
