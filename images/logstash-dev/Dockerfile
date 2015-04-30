FROM cfcommunity/logstash
MAINTAINER You

# Kibana
RUN \
    curl -s https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz | tar -C /opt -xz && \
    ln -s /opt/kibana-4.0.1-linux-x64 /opt/kibana && \
    sed -i 's/port: 5601/port: 5601/' /opt/kibana/config/kibana.yml

ADD etc/supervisor/conf.d/kibana.conf /etc/supervisor/conf.d/kibana.conf

EXPOSE 5601

ADD etc/logstash/logstash.conf /etc/logstash/logstash.conf
