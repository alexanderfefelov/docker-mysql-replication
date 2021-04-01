configure_server_id() {
  cat > /etc/mysql/conf.d/server-id.cnf << EOF
[mysqld]
server-id=$SERVER_ID
EOF
}

configure_log_bin() {
  cat > /etc/mysql/conf.d/log-bin.cnf << EOF
[mysqld]
log-bin=$LOG_BIN
binlog-format=$BINLOG_FORMAT
EOF
}

configure_relay_log() {
  cat > /etc/mysql/conf.d/relay-log.cnf << EOF
[mysqld]
relay-log=$RELAY_LOG
EOF
}

create_replication_account() {
  echo Creating replication account...
  mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="
    CREATE USER '$REPLICATOR_USERNAME'@'%' IDENTIFIED WITH mysql_native_password BY '$REPLICATOR_PASSWORD';
    GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO '$REPLICATOR_USERNAME'@'%';
  "
  echo ...replication account created
}

connect_slave_to_master() {
  echo Connecting slave to master...
  mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="
    CHANGE MASTER TO
      MASTER_HOST='$MASTER_HOST',
      MASTER_PORT=$MASTER_PORT,
      MASTER_USER='$REPLICATOR_USERNAME',
      MASTER_PASSWORD='$REPLICATOR_PASSWORD';
  "
  echo ...slave connected to master
}

start_slave() {
  echo Starting slave...
  mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="
    START SLAVE;
  "
  echo ...slave started
}

init_master() {
  echo Initializing master...
  cp /initdb-master.sh /docker-entrypoint-initdb.d/
  configure_server_id
  configure_log_bin
  echo ...master initialized
}

init_slave() {
  echo Initializing slave...
  cp /initdb-slave.sh /docker-entrypoint-initdb.d/
  configure_server_id
  configure_relay_log
  echo ...slave initialized
}
