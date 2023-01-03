alter database <database-name> collate utf8mb4_bin; -- or utf8_bin on MySQL 5.5.2 or earlier
create user <user-name>@'%' identified by '<password>';
grant ALL ON  <database-name>.* to <user-name>@'%';