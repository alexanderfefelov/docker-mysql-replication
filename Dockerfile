FROM mysql:5.7.25

ENV \
  REPLICATOR_USERNAME=replicator \
  REPLICATOR_PASSWORD=password \
  MASTER_HOST=mysql-master.tld \
  MASTER_PORT=3306 \
  LOG_BIN=log-bin \
  BINLOG_FORMAT=ROW \
  RELAY_LOG=relay-bin

ADD container/ /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]
