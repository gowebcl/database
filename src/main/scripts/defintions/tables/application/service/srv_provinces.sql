drop table if exists srv_provinces cascade;

create table if not exists srv_provinces (
  idf_province numeric,
  txt_province text,
  idf_region numeric,
  constraint srv_provinces_pk primary key (idf_province),
  constraint srv_provinces_fk1 foreign key (idf_region) references srv_regions (idf_region)
);

comment on table srv_provinces is 'spv';