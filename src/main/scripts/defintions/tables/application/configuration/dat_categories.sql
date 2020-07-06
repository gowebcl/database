drop trigger if exists trg_before_update_categories on dat_categories cascade;
drop trigger if exists trg_before_insert_categories on dat_categories cascade;
drop function if exists action_before_update_categories cascade;
drop function if exists action_before_insert_categories cascade;
drop sequence if exists seq_categories cascade;
drop table if exists aud_categories cascade;
drop table if exists dat_categories cascade;

create table if not exists dat_categories (
  idf_category numeric,
  txt_category text,
  idf_community numeric,
  constraint dat_categories_pk primary key (idf_category),
  constraint dat_categories_fk1 foreign key (idf_community) references dat_communities (idf_community)
) inherits (sys_default);

comment on table dat_categories is 'ctg';

create table if not exists aud_categories as
table dat_categories with no data;

alter table aud_categories
add constraint aud_categories_fk0 foreign key (idf_category) references dat_categories (idf_category),
add constraint aud_categories_fk1 foreign key (idf_community) references dat_communities (idf_community);

create index if not exists aud_categories_ix0 on aud_categories (idf_category);
create index if not exists aud_categories_ix1 on aud_categories (idf_community);

create sequence if not exists seq_categories
start with 1 minvalue 1 increment by 1;

create or replace function action_before_insert_categories ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = 1;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_categories
before insert on dat_categories
for each row execute procedure action_before_insert_categories ();

create or replace function action_before_update_categories ()
returns trigger
as $body$
begin

  insert into aud_categories (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_category,
    idf_community,
    txt_category
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_category,
    old.idf_community,
    old.txt_category
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_categories
before update on dat_categories
for each row execute procedure action_before_update_categories ();