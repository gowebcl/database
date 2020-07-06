drop trigger if exists trg_before_update_subcategories on dat_subcategories cascade;
drop trigger if exists trg_before_insert_subcategories on dat_subcategories cascade;
drop function if exists action_before_update_subcategories cascade;
drop function if exists action_before_insert_subcategories cascade;
drop sequence if exists seq_subcategories cascade;
drop table if exists aud_subcategories cascade;
drop table if exists dat_subcategories cascade;

create table if not exists dat_subcategories (
  idf_subcategory numeric,
  txt_subcategory text,
  idf_community numeric,
  idf_category numeric,
  constraint dat_subcategories_pk primary key (idf_subcategory),
  constraint dat_subcategories_fk1 foreign key (idf_community) references dat_communities (idf_community),
  constraint dat_subcategories_fk2 foreign key (idf_category) references dat_categories (idf_category)
) inherits (sys_default);

comment on table dat_subcategories is 'stg';

create table if not exists aud_subcategories as
table dat_subcategories with no data;

alter table aud_subcategories
add constraint aud_subcategories_fk0 foreign key (idf_subcategory) references dat_subcategories (idf_subcategory),
add constraint aud_subcategories_fk1 foreign key (idf_community) references dat_communities (idf_community),
add constraint aud_subcategories_fk2 foreign key (idf_category) references dat_categories (idf_category);

create index if not exists aud_subcategories_ix0 on aud_subcategories (idf_subcategory);
create index if not exists aud_subcategories_ix1 on aud_subcategories (idf_community);
create index if not exists aud_subcategories_ix2 on aud_subcategories (idf_category);

create sequence if not exists seq_subcategories
start with 1 minvalue 1 increment by 1;

create or replace function action_before_insert_subcategories ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = 1;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_subcategories
before insert on dat_subcategories
for each row execute procedure action_before_insert_subcategories ();

create or replace function action_before_update_subcategories ()
returns trigger
as $body$
begin

  insert into aud_subcategories (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_category,
    idf_community,
    idf_subcategory,
    txt_subcategory
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_category,
    old.idf_community,
    old.idf_subcategory,
    old.txt_subcategory
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_subcategories
before update on dat_subcategories
for each row execute procedure action_before_update_subcategories ();