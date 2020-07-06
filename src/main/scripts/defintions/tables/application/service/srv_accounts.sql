drop table if exists srv_accounts cascade;

create table if not exists srv_accounts (
  idf_account numeric,
  txt_account text,
  idf_category numeric,
  idf_subcategory numeric,
  txt_account_plan text,
  constraint srv_accounts_pk primary key (idf_account),
  constraint srv_accounts_fk1 foreign key (idf_category) references srv_categories (idf_category),
  constraint srv_accounts_fk2 foreign key (idf_subcategory) references srv_subcategories (idf_subcategory)
);

comment on table srv_accounts is 'sac';