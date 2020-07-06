drop table if exists srv_regions cascade;

create table if not exists srv_regions (
  idf_region numeric,
  txt_region text,
  constraint srv_regions_pk primary key (idf_region)
);

comment on table srv_regions is 'srg';