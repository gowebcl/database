drop trigger if exists trg_before_update_types on dat_types cascade;
drop trigger if exists trg_before_insert_types on dat_types cascade;
drop function if exists action_before_update_types cascade;
drop function if exists action_before_insert_types cascade;
drop table if exists aud_types cascade;
drop table if exists dat_types cascade;

create table if not exists dat_types (
  idf_type numeric,
  txt_type text,
  idf_community numeric,
  constraint dat_types_pk primary key (idf_type),
  constraint dat_types_fk1 foreign key (idf_community) references dat_communities (idf_community)
) inherits (sys_default);

comment on table dat_types is 'typ';

create table if not exists aud_types as
table dat_types with no data;

alter table aud_types
add constraint dat_types_fk0 foreign key (idf_type) references dat_types (idf_type),
add constraint dat_types_fk1 foreign key (idf_community) references dat_communities (idf_community);

create index if not exists aud_types_ix0 on aud_types (idf_type);

create sequence if not exists seq_types
start with 1 increment by 1;

create or replace function action_before_insert_types ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_file_types
before insert on dat_types
for each row execute procedure action_before_insert_types ();

create or replace function action_before_update_types ()
returns trigger
as $body$
begin

  insert into aud_types (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_community,
    idf_type,
    txt_type
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_community,
    old.idf_type,
    old.txt_type
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_types
before update on dat_types
for each row execute procedure action_before_update_types ();