alter database <database-name> collate utf8mb4_bin;
create user <user-name> identified by '<password>';
grant ALL ON  <database-name>.* to <user-name>;
grant all privileges on <database-name>.* to <user-name>;
grant PROCESS ON *.* to <user-name>;
alter user <user-name> identified by '<password>';