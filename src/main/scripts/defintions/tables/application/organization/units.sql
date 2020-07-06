drop trigger if exists trg_before_update_owners on dat_owners cascade;
drop trigger if exists trg_before_insert_owners on dat_owners cascade;
drop trigger if exists trg_before_update_ownerships_units on dat_ownerships_units cascade;
drop trigger if exists trg_before_insert_ownerships_units on dat_ownerships_units cascade;
drop trigger if exists trg_before_update_units on dat_units cascade;
drop trigger if exists trg_before_insert_units on dat_units cascade;
drop function if exists action_before_update_owners cascade;
drop function if exists action_before_insert_owners cascade;
drop function if exists action_before_update_ownerships_units cascade;
drop function if exists action_before_insert_ownerships_units cascade;
drop function if exists action_before_update_units cascade;
drop function if exists action_before_insert_units cascade;
drop sequence if exists seq_owners cascade;
drop sequence if exists seq_ownerships_units cascade;
drop sequence if exists seq_units cascade;
drop table if exists aud_owners cascade;
drop table if exists dat_owners cascade;
drop table if exists aud_ownerships_units cascade;
drop table if exists dat_ownerships_units cascade;
drop table if exists aud_units cascade;
drop table if exists dat_units cascade;

/* UNITS */

create table if not exists dat_units (
  idf_unit numeric,
  txt_unit text,
  idf_community numeric,
  num_aliquot numeric,
  constraint dat_units_pk primary key (idf_unit),
  constraint dat_units_fk1 foreign key (idf_community) references dat_communities (idf_community)
) inherits (sys_default);

comment on table dat_units is 'unt';

create table if not exists aud_units as
table dat_units with no data;

alter table aud_units
add constraint aud_units_fk1 foreign key (idf_unit) references dat_units (idf_unit);

create index if not exists aud_units_ix1 on aud_units (
  idf_unit
);

create sequence if not exists seq_units
start with 1 increment by 1;

create or replace function action_before_insert_units ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_units
before insert on dat_units
for each row execute procedure action_before_insert_units ();

create or replace function action_before_update_units ()
returns trigger
as $body$
begin

  insert into aud_units (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_community,
    idf_unit,
    num_aliquot,
    txt_unit
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_community,
    old.idf_unit,
    old.num_aliquot,
    old.txt_unit
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_units
before update on dat_units
for each row execute procedure action_before_update_units ();

/* OWNERSHIPS BY UNITS */

create table if not exists dat_ownerships_units (
  idf_ownership_unit numeric,
  idf_ownership numeric,
  idf_unit numeric,
  constraint dat_ownerships_units_pk primary key (idf_ownership_unit),
  constraint dat_ownerships_units_fk1 foreign key (idf_ownership) references dat_ownerships (idf_ownership),
  constraint dat_ownerships_units_fk2 foreign key (idf_unit) references dat_units (idf_unit)
) inherits (sys_default);

comment on table dat_ownerships_units is 'oun';

create table if not exists aud_ownerships_units as
table dat_ownerships_units with no data;

alter table aud_ownerships_units
add constraint aud_ownerships_units_fk1 foreign key (idf_ownership_unit) references dat_ownerships_units (idf_ownership_unit);

create index if not exists aud_ownerships_units_ix1 on aud_ownerships_units (idf_ownership);
create index if not exists aud_ownerships_units_ix2 on aud_ownerships_units (idf_unit);
create index if not exists aud_ownerships_units_ix3 on aud_ownerships_units (idf_ownership, idf_unit);

create sequence if not exists seq_ownerships_units
start with 1 increment by 1;

create or replace function action_before_insert_ownerships_units ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_ownerships_units_communities
before insert on dat_ownerships_units
for each row execute procedure action_before_insert_ownerships_units ();

create or replace function action_before_update_ownerships_units ()
returns trigger as $body$
begin

  insert into aud_ownerships_units (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_ownership,
    idf_ownership_unit,
    idf_unit
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_ownership,
    old.idf_ownership_unit,
    old.idf_unit
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_ownerships_units
before update on dat_ownerships_units
for each row execute procedure action_before_update_ownerships_units ();

/* OWNERS */

create table if not exists dat_owners (
  idf_owner numeric,
  txt_first_name text,
  txt_last_name text,
  txt_business_name text,
  idf_person_type numeric,
  constraint dat_owners_pk primary key (idf_owner),
  constraint dat_owners_fk1 foreign key (idf_person_type) references srv_persons (idf_person)
) inherits (sys_default);

comment on table dat_owners is 'own';

create table if not exists aud_owners as
table dat_owners with no data;

alter table aud_owners
add constraint aud_owners_fk1 foreign key (idf_owner) references dat_owners (idf_owner);

create index if not exists aud_owners_ix1 on aud_owners (idf_owner);

create sequence if not exists seq_owners
start with 1 increment by 1;

create or replace function action_before_insert_owners ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_owners
before insert on dat_owners
for each row execute procedure action_before_insert_owners ();

create or replace function action_before_update_owners ()
returns trigger
as $body$
begin

  insert into aud_owners (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_owner,
    idf_person_type,
    txt_business_name,
    txt_first_name,
    txt_last_name
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_owner,
    old.idf_person_type,
    old.txt_business_name,
    old.txt_first_name,
    old.txt_last_name
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_owners
before update on dat_owners
for each row execute procedure action_before_update_owners ();