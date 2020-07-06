drop table if exists srv_persons cascade;

create table if not exists srv_persons (
  idf_person numeric,
  txt_person text,
  constraint srv_persons_pk primary key (idf_person)
);

comment on table srv_persons is 'spe';