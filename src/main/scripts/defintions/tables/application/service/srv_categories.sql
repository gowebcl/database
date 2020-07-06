drop table if exists srv_categories cascade;

create table if not exists srv_categories (
  idf_category numeric,
  txt_category text,
  constraint srv_categories_pk primary key (idf_category)
);

comment on table srv_categories is 'scg';