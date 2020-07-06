drop table if exists srv_subcategories cascade;

create table if not exists srv_subcategories (
  idf_subcategory numeric,
  txt_subcategory text,
  idf_category numeric,
  constraint srv_subcategories_pk primary key (idf_subcategory),
  constraint srv_subcategories_fk1 foreign key (idf_category) references srv_categories (idf_category)
);

comment on table srv_subcategories is 'ssc';