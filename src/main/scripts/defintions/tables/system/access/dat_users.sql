drop trigger if exists trg_before_update_users on dat_users cascade;
drop trigger if exists trg_before_insert_users on dat_users cascade;
drop function if exists action_before_update_users cascade;
drop function if exists action_before_insert_users cascade;
drop sequence if exists seq_users cascade;
drop table if exists aud_users cascade;
drop table if exists dat_users cascade;

create table if not exists dat_users (
  idf_user numeric,
  txt_username text,
  txt_password text,
  txt_first_name text,
  txt_last_name text,
  txt_business_name text,
  idf_person numeric,
  constraint dat_users_pk primary key (idf_user),
  constraint dat_users_fk1 foreign key (idf_person) references srv_persons (idf_person)
) inherits (sys_default);

comment on table dat_users is 'usr';

create table if not exists aud_users as
table dat_users with no data;

alter table aud_users
add constraint aud_users_fk0 foreign key (idf_user) references dat_users (idf_user),
add constraint aud_users_fk1 foreign key (idf_person) references srv_persons (idf_person);

create index if not exists aud_users_ix0 on aud_users (idf_user);

create sequence if not exists seq_users
start with 1 minvalue 1 increment by 1;

create or replace function action_before_insert_users ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_users
before insert on dat_users
for each row execute procedure action_before_insert_users ();

create or replace function action_before_update_users ()
returns trigger as $body$
begin

  insert into aud_users (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_person,
    idf_user,
    txt_business_name,
    txt_first_name,
    txt_last_name,
    txt_password,
    txt_username
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_person,
    old.idf_user,
    old.txt_business_name,
    old.txt_first_name,
    old.txt_last_name,
    old.txt_password,
    old.txt_username
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_users
before update on dat_users
for each row execute procedure action_before_update_users ();