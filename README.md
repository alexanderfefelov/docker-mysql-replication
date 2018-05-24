## Environment variables

For both master and slave:

* `SERVER_ID`, number, mandatory, no default value
* `MODE`, string, `master` or `slave`, mandatory, no default value
* `REPLICATOR_USERNAME`, string, optional, default `replicator`
* `REPLICATOR_PASSWORD`, string, optional, default `password`

For master only:

* `LOG_BIN`, string, optional, default `log-bin`

For slave only:

* `MASTER_HOST`, string, optional, default `mysql-master.tld`
* `MASTER_PORT`, number, optional, default `3306`
* `RELAY_LOG`, string, optional, default `relay-bin`

## Start master

Run something like

    docker run --name mysql-master-42 \
      --detach \
      --env SERVER_ID=42 \
      --env MODE=master \
      --env MYSQL_ROOT_PASSWORD=password \
      --publish 10000:3306 \
      alexanderfefelov/mysql-replication \
    && docker run --rm --link mysql-master-42:foobar martin/wait -t 300

and master with server ID 42 will be available at port 10000.

## Start slave(s)

After executing something like

    docker run --name mysql-slave-24 \
      --detach \
      --env SERVER_ID=24 \
      --env MODE=slave \
      --env MASTER_HOST=192.168.1.123 \
      --env MASTER_PORT=10000 \
      --env MYSQL_ROOT_PASSWORD=password \
      --publish 12345:3306 \
      alexanderfefelov/mysql-replication \
    && docker run --rm --link mysql-slave-24:foobar martin/wait -t 300 \
    && docker exec mysql-slave-24 cp /read-only.cnf /etc/mysql/mysql.conf.d/ \
    && docker restart mysql-slave-24 \
    && docker run --rm --link mysql-slave-24:foobar martin/wait -t 300

slave with server ID 24 will be available at port 12345.
