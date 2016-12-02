FROM nimmis/java-centos

MAINTAINER lovepocky

ENV http_proxy=http://192.168.1.113:1087
RUN yum update -y && \
yum install -y net-tools

ENV KAFKA_VERSION="0.10.1.0" SCALA_VERSION="2.11"
ADD download-kafka.sh /tmp/download-kafka.sh
ADD jq-1.3-2.el7.x86_64.rpm /tmp/jq-1.3-2.el7.x86_64.rpm
RUN rpm -iv /tmp/jq-1.3-2.el7.x86_64.rpm
RUN chmod a+x /tmp/download-kafka.sh && sync && /tmp/download-kafka.sh && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
ADD create-topics.sh /usr/bin/create-topics.sh
# The scripts need to have executable permission
RUN chmod a+x /usr/bin/start-kafka.sh && \
    chmod a+x /usr/bin/broker-list.sh && \
    chmod a+x /usr/bin/create-topics.sh
# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
