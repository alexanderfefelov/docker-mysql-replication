## Environment variables

* `SERVER_ID` (mandatory, no default value)
* `MODE` (`master` or `slave`, mandatory, no default value)
* `REPLICATOR_USERNAME` (optional, default `replicator`)
* `REPLICATOR_PASSWORD` (optional, default `password`)
* `MASTER_HOST` (optional, default `mysql-master.tld`)
* `MASTER_PORT` (optional, default `3306`)

## Start master

After executing something like

    docker run --name mysql-master-42 \
      --detach \
      --env SERVER_ID=42 \
      --env MODE=master \
      --env MYSQL_ROOT_PASSWORD=password \
      --publish 10000:3306 \
      alexanderfefelov/mysql-replication \
    && docker run --rm --link mysql-master-42:foobar martin/wait -t 300 \
    && docker restart mysql-master-42 \
    && docker run --rm --link mysql-master-42:foobar martin/wait -t 300

master with server ID 42 will be available at port 10000.

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
    && docker run --rm --link mysql-slave-24:foobar martin/wait -t 300

slave with server ID 24 will be available at port 12345.
