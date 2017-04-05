docker-mosquitto-auth-postgres
================

Dockerfile and docker-compose for Mosquitto MQTT Broker with auth-plugin using Postgres.

# Build and run

    $ docker-compose build
    $ docker-compose up
### Create tables on db

```bash
$ docker exec -it mosquitto_db psql -U mqtt     


create table account(
  id SERIAL,
  username TEXT NOT NULL,
  password TEXT,
  super smallint DEFAULT 0 NOT NULL,
  PRIMARY KEY (id)
);

CREATE INDEX account_username ON account (username);

CREATE TABLE acls (
  id SERIAL,
  username TEXT NOT NULL,
  topic TEXT NOT NULL,
  rw INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE UNIQUE INDEX acls_user_topic ON acls (username, topic);
```

## Adding new users and permissions

First create a hashed password with  
``` $ python utils/password/np.py```  

Get the value and update the tables:  

```
$ docker exec -it mosquitto_db psql -U mqtt -c "insert into account (username, password, super) values ('username', 'PBKDF2$sha256$901$mSXeQ5MPEpemtPtY$F7GbpbSLptt7', 0);"
$ docker exec -it mosquitto_db psql -U mqtt -c "insert into acls (username, topic, rw) values ('username', 'test/#', 2);"
```
