drop table if exists srv_keys cascade;

create table if not exists srv_keys (
  idf_key numeric,
  txt_key text,
  constraint srv_keys_pk primary key (idf_key)
);

comment on table srv_keys is 'sky';