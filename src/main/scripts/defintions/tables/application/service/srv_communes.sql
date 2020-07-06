drop table if exists srv_communes cascade;

create table if not exists srv_communes  (
  idf_commune numeric,
  txt_commune text,
  idf_region numeric,
  idf_province numeric,
  constraint srv_communes_pk primary key (idf_commune),
  constraint srv_communes_fk1 foreign key (idf_region) references srv_regions (idf_region),
  constraint srv_communes_fk2 foreign key (idf_province) references srv_provinces (idf_province)
);

comment on table srv_communes is 'scm';