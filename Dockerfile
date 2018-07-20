FROM       alpine
MAINTAINER Alexandru Grigoras <alexandru.grigoras86@gmail.com>
ARG        DIST_MIRROR=http://archive.apache.org/dist/nifi
ARG        VERSION=1.6.0
ENV        NIFI_HOME=/opt/nifi \
           JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk \
           PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin \
           PHANTOMJS_ARCHIVE="phantomjs.tar.gz" \
           LC_ALL=C
RUN        apk add --no-cache bash curl openjdk8 && \
           mkdir -p ${NIFI_HOME} && \
           curl ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_HOME} && \
           mv ${NIFI_HOME}/nifi-${VERSION}/* ${NIFI_HOME} && \
           rm -rf ${NIFI_HOME}/nifi-${VERSION} && \
           rm -rf *.tar.gz \
           && echo '@edge http://nl.alpinelinux.org/alpine/edge/main'>> /etc/apk/repositories \
           && apk --update add curl python sshpass \
           && curl -Lk -o $PHANTOMJS_ARCHIVE https://github.com/fgrehm/docker-phantomjs2/releases/download/v2.0.0-20150722/dockerized-phantomjs.tar.gz \
           && tar -xf $PHANTOMJS_ARCHIVE -C /tmp/ && cp -R /tmp/etc/fonts /etc/ && cp -R /tmp/lib/* /lib/ && cp -R /tmp/lib64 / && cp -R /tmp/usr/lib/* /usr/lib/ \
           && cp -R /tmp/usr/lib/x86_64-linux-gnu /usr/ && cp -R /tmp/usr/share/* /usr/share/ && cp /tmp/usr/local/bin/phantomjs /usr/bin/ && rm -fr $PHANTOMJS_ARCHIVE /tmp/*
EXPOSE     8080 8081 8443
VOLUME     ${NIFI_HOME}/logs \
           ${NIFI_HOME}/flowfile_repository \
           ${NIFI_HOME}/database_repository \
           ${NIFI_HOME}/content_repository \
           ${NIFI_HOME}/provenance_repository
WORKDIR    ${NIFI_HOME}
CMD        ./bin/nifi.sh run
