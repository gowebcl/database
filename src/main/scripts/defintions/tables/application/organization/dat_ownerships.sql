drop trigger if exists trg_before_update_ownerships on dat_ownerships cascade;
drop trigger if exists trg_before_insert_ownerships on dat_ownerships cascade;
drop function if exists action_before_update_ownerships cascade;
drop function if exists action_before_insert_ownerships cascade;
drop sequence if exists seq_ownerships cascade;
drop table if exists aud_ownerships cascade;
drop table if exists dat_ownerships cascade;

create table if not exists dat_ownerships (
  idf_ownership numeric,
  txt_ownership text,
  idf_community numeric,
  idf_property numeric,
  num_floor numeric,
  num_aliquot numeric,
  constraint dat_ownerships_pk primary key (idf_ownership),
  constraint dat_ownerships_fk1 foreign key (idf_community) references dat_communities (idf_community),
  constraint dat_ownerships_fk2 foreign key (idf_property) references srv_properties (idf_property)
) inherits (sys_default);

comment on table dat_ownerships is 'ows';

create table if not exists aud_ownerships as
table dat_ownerships with no data;

alter table aud_ownerships
add constraint aud_ownerships_fk0 foreign key (idf_ownership) references dat_ownerships (idf_ownership),
add constraint aud_ownerships_fk1 foreign key (idf_community) references dat_communities (idf_community);

create index if not exists aud_ownerships_ix1 on aud_ownerships (idf_ownership);

create sequence if not exists seq_ownerships
start with 1 increment by 1;

create or replace function action_before_insert_ownerships ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_ownerships
before insert on dat_ownerships
for each row execute procedure action_before_insert_ownerships ();

create or replace function action_before_update_ownerships ()
returns trigger
as $body$
begin

  insert into aud_ownerships (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_community,
    idf_ownership,
    idf_property,
    num_aliquot,
    num_floor,
    txt_ownership
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_community,
    old.idf_ownership,
    old.idf_property,
    old.num_aliquot,
    old.num_floor,
    old.txt_ownership
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_ownerships
before update on dat_ownerships
for each row execute procedure action_before_update_ownerships ();