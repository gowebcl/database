drop table if exists srv_types;

create table if not exists srv_types (
  idf_type numeric,
  txt_type text,
  constraint srv_types_pk primary key (idf_type)
);

comment on table srv_types is 'sfl';