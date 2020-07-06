drop table if exists sys_default cascade;

create table if not exists sys_default (
  sys_timestamp timestamp,
  sys_status boolean,
  sys_user numeric,
  sys_version numeric
);