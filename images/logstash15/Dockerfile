FROM frodenas/java7
MAINTAINER Long Nguyen & Dr Nic Williams

ENV DEBIAN_FRONTEND noninteractive

RUN \
# Elasticsearch
    apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4 && \
    if ! grep "elasticsearch" /etc/apt/sources.list; then echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" >> /etc/apt/sources.list;fi && \
    if ! grep "logstash" /etc/apt/sources.list; then echo "deb http://packages.elastic.co/logstash/1.5/debian stable main" >> /etc/apt/sources.list;fi && \
    apt-get update && \
    apt-get install -y supervisor curl && \
    apt-get install -y elasticsearch && \
    apt-get install -y logstash && \
    apt-get clean && \
    sed -i '/#path.data: \/path\/to\/data/a path.data: /data' /etc/elasticsearch/elasticsearch.yml

ADD etc/supervisor/conf.d/elasticsearch.conf /etc/supervisor/conf.d/elasticsearch.conf
ADD etc/supervisor/conf.d/logstash.conf /etc/supervisor/conf.d/logstash.conf

ADD etc/logstash/logstash.conf /etc/logstash/logstash.conf
ADD etc/kibana/config.js /opt/logstash/vendor/kibana/config.js


ADD scripts /scripts
RUN chmod +x /scripts/*.sh

RUN /usr/share/elasticsearch/bin/plugin install elasticsearch/elasticsearch-cloud-aws/2.4.2

ENTRYPOINT ["/scripts/run.sh"]
CMD [""]

EXPOSE 514
EXPOSE 9200
EXPOSE 9300

VOLUME ["/data"]
