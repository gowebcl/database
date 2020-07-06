/*drop trigger if exists trg_before_update_users_profiles on dat_users_profiles cascade;
drop trigger if exists trg_before_insert_users_profiles on dat_users_profiles cascade;
drop trigger if exists trg_before_update_profiles on dat_profiles cascade;
drop trigger if exists trg_before_insert_profiles on dat_profiles cascade;
drop function if exists action_before_update_users_profiles cascade;
drop function if exists action_before_insert_users_profiles cascade;
drop function if exists action_before_update_profiles cascade;
drop function if exists action_before_insert_profiles cascade;
drop sequence if exists seq_users_profiles cascade;
drop sequence if exists seq_profiles cascade;
drop table if exists aud_users_profiles cascade;
drop table if exists dat_users_profiles cascade;
drop table if exists aud_profiles cascade;
drop table if exists dat_profiles cascade;
*/
/* PROFILES */

create table if not exists dat_profiles (
  idf_profile numeric,
  txt_profile text,
  idf_community numeric,
  constraint dat_profiles_pk primary key (idf_profile),
  constraint dat_profiles_fk1 foreign key (idf_community) references dat_communities (idf_community)
) inherits (sys_default);

comment on table dat_profiles is 'prf';

create table if not exists aud_profiles as
table dat_profiles with no data;

alter table aud_profiles
add constraint aud_profiles_fk0 foreign key (idf_profile) references dat_profiles (idf_profile),
add constraint aud_profiles_fk1 foreign key (idf_community) references dat_communities (idf_community);

create index if not exists aud_profile_ix0 on aud_profiles (idf_profile);
create index if not exists aud_profile_ix1 on aud_profiles (idf_community);

create sequence if not exists seq_profiles
start with 1 minvalue 1 increment by 1;

create or replace function action_before_insert_profiles ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_profiles
before insert on dat_profiles
for each row execute procedure action_before_insert_profiles ();

create or replace function action_before_update_profiles ()
returns trigger as $body$
begin

  insert into aud_profiles (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_community,
    idf_profile,
    txt_profile
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_community,
    old.idf_profile,
    old.txt_profile
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_profiles
before update on dat_profiles
for each row execute procedure action_before_update_profiles ();

/* USERS BY PROFILES */
/*
create table if not exists dat_users_profiles (
  idf_users_profiles numeric,
  idf_user numeric,
  idf_community numeric,
  idf_profile numeric,
  constraint dat_users_profiles_pk primary key (idf_users_profiles),
  constraint dat_users_profiles_fk1 foreign key (idf_community) references dat_communities (idf_community),
  constraint dat_users_profiles_fk2 foreign key (idf_user) references dat_users (idf_user),
  constraint dat_users_profiles_fk3 foreign key (idf_profile) references dat_profiles (idf_profile)
) inherits (sys_default);

comment on table dat_users_profiles is 'upf';

create table if not exists aud_users_profiles as
table dat_users_profiles with no data;

alter table aud_users_profiles
add constraint aud_users_profiles_fk0 foreign key (idf_users_profiles) references dat_users_profiles (idf_users_profiles),
add constraint aud_users_profiles_fk1 foreign key (idf_community) references dat_communities (idf_community),
add constraint aud_users_profiles_fk2 foreign key (idf_user) references dat_users (idf_user),
add constraint aud_users_profiles_fk3 foreign key (idf_profile) references dat_profiles (idf_profile);

create index if not exists aud_users_profiles_ix0 on aud_users_profiles (idf_users_profiles);
create index if not exists aud_users_profiles_ix1 on aud_users_profiles (idf_community);
create index if not exists aud_users_profiles_ix2 on aud_users_profiles (idf_user);
create index if not exists aud_users_profiles_ix3 on aud_users_profiles (idf_profile);

create sequence if not exists seq_users_profiles
start with 1 minvalue 1 increment by 1;

create or replace function action_before_insert_users_profiles ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_users_profiles
before insert on dat_users_profiles
for each row execute procedure action_before_insert_users_profiles ();

create or replace function action_before_update_users_profiles ()
returns trigger as $body$
begin

  insert into aud_users_profiles (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_community,
    idf_profile,
    idf_user,
    idf_users_profiles
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_community,
    old.idf_profile,
    old.idf_user,
    old.idf_users_profiles
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_users_profiles
before update on dat_users_profiles
for each row execute procedure action_before_update_users_profiles ();*/