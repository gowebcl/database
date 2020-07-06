drop table if exists srv_properties cascade;

create table if not exists srv_properties (
  idf_property numeric,
  txt_property text,
  constraint srv_properties_pk primary key (idf_property)
);

comment on table srv_properties is 'spt';