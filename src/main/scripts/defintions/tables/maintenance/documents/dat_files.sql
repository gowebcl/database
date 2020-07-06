drop trigger if exists trg_before_update_files on dat_files cascade;
drop trigger if exists trg_before_insert_files on dat_files cascade;
drop function if exists action_before_update_files cascade;
drop function if exists action_before_insert_files cascade;
drop sequence if exists seq_files cascade;
drop sequence if exists seq_types cascade;
drop table if exists aud_files cascade;
drop table if exists dat_files cascade;

create table if not exists dat_files (
  idf_file numeric,
  txt_file text,
  txt_location text,
  idf_community numeric,
  idf_type numeric,
  constraint dat_files_pk primary key (idf_file),
  constraint dat_files_fk1 foreign key (idf_community) references dat_communities (idf_community),
  constraint dat_files_fk2 foreign key (idf_type) references dat_types (idf_type)
) inherits (sys_default);

comment on table dat_files is 'fls';

create table if not exists aud_files as
table dat_files with no data;

alter table aud_files
add constraint dat_files_fk0 foreign key (idf_file) references dat_files (idf_file),
add constraint dat_files_fk1 foreign key (idf_community) references dat_communities (idf_community);

create index if not exists aud_files_ix0 on aud_files (idf_file);

create sequence if not exists seq_files
start with 1 increment by 1;

create or replace function action_before_insert_files ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_files
before insert on dat_files
for each row execute procedure action_before_insert_files ();

create or replace function action_before_update_files ()
returns trigger
as $body$
begin

  insert into aud_files (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_file,
    txt_file,
    txt_location,
    idf_community,
    idf_type
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_file,
    old.txt_file,
    old.txt_location,
    old.idf_community,
    old.idf_type
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_files
before update on dat_files
for each row execute procedure action_before_update_files ();