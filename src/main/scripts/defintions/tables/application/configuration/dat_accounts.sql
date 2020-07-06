drop trigger if exists trg_before_update_accounts on dat_accounts cascade;
drop trigger if exists trg_before_insert_accounts on dat_accounts cascade;
drop function if exists action_before_update_accounts cascade;
drop function if exists action_before_insert_accounts cascade;
drop sequence if exists seq_accounts cascade;
drop table if exists aud_accounts cascade;
drop table if exists dat_accounts cascade;

create table if not exists dat_accounts (
  idf_account numeric,
  txt_account text,
  idf_community numeric,
  idf_category numeric,
  idf_subcategory numeric,
  constraint dat_accounts_pk primary key (idf_account),
  constraint dat_accounts_fk1 foreign key (idf_community) references dat_communities (idf_community),
  constraint dat_accounts_fk2 foreign key (idf_category) references dat_categories (idf_category),
  constraint dat_accounts_fk3 foreign key (idf_subcategory) references dat_subcategories (idf_subcategory)
) inherits (sys_default);

comment on table dat_accounts is 'acc';

create table if not exists aud_accounts as
table dat_accounts with no data;

alter table aud_accounts
add constraint aud_accounts_fk0 foreign key (idf_account) references dat_accounts (idf_account),
add constraint aud_accounts_fk1 foreign key (idf_community) references dat_communities (idf_community),
add constraint aud_accounts_fk2 foreign key (idf_category) references dat_categories (idf_category),
add constraint aud_accounts_fk3 foreign key (idf_subcategory) references dat_subcategories (idf_subcategory);

create index if not exists aud_accounts_ix0 on aud_accounts (idf_account);
create index if not exists aud_accounts_ix1 on aud_accounts (idf_category);
create index if not exists aud_accounts_ix2 on aud_accounts (idf_subcategory);

create sequence if not exists seq_accounts
start with 1 increment by 1;

create or replace function action_before_insert_accounts ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = 1;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_accounts
before insert on dat_accounts
for each row execute procedure action_before_insert_accounts ();

create or replace function action_before_update_accounts ()
returns trigger
as $body$
begin

  insert into aud_accounts (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_account,
    txt_account,
    idf_community,
    idf_category,
    idf_subcategory
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_account,
    old.txt_account,
    old.idf_community,
    old.idf_category,
    old.idf_subcategory
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_accounts
before update on dat_accounts
for each row execute procedure action_before_update_accounts ();