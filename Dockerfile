FROM nkeating/java-minimal

MAINTAINER Noel Keating

RUN apk --update add bash

ENV KAFKA_VERSION=0.8.2.2 KAFKA_SCALA_VERSION=2.10
ENV KAFKA_RELEASE=kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}

# Install Kafka to /kafka
RUN wget http://ftp.heanet.ie/mirrors/www.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_RELEASE}.tgz && \
  tar zxf ${KAFKA_RELEASE}.tgz && \
  rm ${KAFKA_RELEASE}.tgz && \
  mv ${KAFKA_RELEASE} /kafka

RUN /usr/sbin/adduser -s /sbin/nologin -D -H kafka kafka && \
  mkdir -p /tmp/kafka-logs && \
  chown -R kafka:kafka /kafka /tmp/kafka-logs

USER kafka
ENV PATH /kafka/bin:$PATH
WORKDIR /kafka

VOLUME [ "/tmp/kafka-logs" ]

EXPOSE 9092

ENTRYPOINT [ "kafka-server-start.sh", "config/server.properties" ]
