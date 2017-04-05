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