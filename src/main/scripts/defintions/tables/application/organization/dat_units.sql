drop trigger if exists trg_before_update_units on dat_units cascade;
drop trigger if exists trg_before_insert_units on dat_units cascade;
drop function if exists action_before_update_units cascade;
drop function if exists action_before_insert_units cascade;
drop sequence if exists seq_units cascade;
drop table if exists aud_units cascade;
drop table if exists dat_units cascade;

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