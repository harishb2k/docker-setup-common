FROM ubuntu:16.04
RUN apt-get update
RUN apt-get -y install zookeeperd
RUN apt-get -y install default-jre
RUN apt-get -y install supervisor

# Setup supervisor
RUN mkdir -p /var/log/supervisor

# Install Kafka
RUN mkdir -p /usr/local/kafka
COPY ./download/kafka_2.11-2.2.0.tgz kafka_2.11-2.2.0.tgz
RUN tar xvf kafka_2.11-2.2.0.tgz
RUN mv kafka_2.11-2.2.0 /usr/local/
RUN echo "" >> /usr/local/kafka_2.11-2.2.0/config/server.properties
RUN echo "delete.topic.enable = true" >> /usr/local/kafka_2.11-2.2.0/config/server.properties
RUN echo "" >> /usr/local/kafka_2.11-2.2.0/config/server.properties
RUN echo "advertised.listeners=PLAINTEXT://localhost:9092" >> /usr/local/kafka_2.11-2.2.0/config/server.properties
RUN echo "" >> /usr/local/kafka_2.11-2.2.0/config/server.properties

RUN apt -y install redis-server
RUN echo "" >> /etc/redis/redis.conf
RUN echo "bind 0.0.0.0" >> /etc/redis/redis.conf

RUN apt-get -y install nodejs
RUN apt-get -y install npm
RUN npm install -g --unsafe-perm node-red


COPY command.sh .
RUN mkdir -p /etc/supervisor/conf.d/
COPY ./supervisord.conf /etc/supervisor/conf.d/

CMD ["/bin/bash", "command.sh"]


