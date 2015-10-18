FROM rpidockers/java:1.8.0_60

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN arch="$(dpkg --print-architecture)" \
	&& set -x \
	&& curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch" \
	&& curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch.asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

ENV LS_VERSION 1.5.4

RUN cd /opt && \
    wget https://download.elastic.co/logstash/logstash/logstash-$LS_VERSION.tar.gz && \
    tar -xvzf logstash-$LS_VERSION.tar.gz && \
    rm logstash-$LS_VERSION.tar.gz && \
    ln -s logstash-$LS_VERSION logstash

# Workaround for bug https://github.com/jruby/jruby/issues/1561
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential ant && \
    cd /tmp && \
    wget https://github.com/jnr/jffi/archive/1.2.9.tar.gz && \
    tar -xvzf 1.2.9.tar.gz && \
    cd jffi-1.2.9/ && \
    ant jar && \
    cp build/jni/libjffi-1.2.so /opt/logstash/vendor/jruby/lib/jni/arm-Linux/ && \
    cd /tmp && \
    rm -rf jffi-1.2.9

RUN useradd logstash
    
ENV PATH /opt/logstash/bin:$PATH
ENV LS_HEAP_SIZE 64m

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["logstash", "agent"]
