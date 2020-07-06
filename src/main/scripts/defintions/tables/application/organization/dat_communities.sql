drop trigger if exists trg_before_update_communities on dat_communities cascade;
drop trigger if exists trg_before_insert_communities on dat_communities cascade;
drop function if exists action_before_update_communities cascade;
drop function if exists action_before_insert_communities cascade;
drop sequence if exists seq_communities cascade;
drop table if exists aud_communities cascade;
drop table if exists dat_communities cascade;

create table if not exists dat_communities (
  idf_community numeric,
  num_unique_rol numeric,
  txt_check_digit text,
  txt_community text,
  txt_address text,
  idf_region numeric,
  idf_province numeric,
  idf_commune numeric,
  txt_email text,
  num_postal_code numeric,
  txt_location text,
  idf_condominium numeric,
  constraint dat_communities_pk primary key (idf_community),
  constraint dat_communities_fk1 foreign key (idf_region) references srv_regions (idf_region),
  constraint dat_communities_fk2 foreign key (idf_province) references srv_provinces (idf_province),
  constraint dat_communities_fk3 foreign key (idf_commune) references srv_communes (idf_commune),
  constraint dat_communities_fk4 foreign key (idf_condominium) references srv_condominiums (idf_condominium)
) inherits (sys_default);

comment on table dat_communities is 'com';

create table if not exists aud_communities as
table dat_communities with no data;

alter table aud_communities
add constraint aud_communities_fk0 foreign key (idf_community) references dat_communities (idf_community),
add constraint aud_communities_fk1 foreign key (idf_region) references srv_regions (idf_region),
add constraint aud_communities_fk2 foreign key (idf_province) references srv_provinces (idf_province),
add constraint aud_communities_fk3 foreign key (idf_commune) references srv_communes (idf_commune),
add constraint aud_communities_fk4 foreign key (idf_condominium) references srv_condominiums (idf_condominium);

create index if not exists aud_communities_ix0 on aud_communities (idf_community);

create sequence if not exists seq_communities
start with 1 increment by 1;

create or replace function action_before_insert_communities ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_communities
before insert on dat_communities
for each row execute procedure action_before_insert_communities ();

create or replace function action_before_update_communities ()
returns trigger
as $body$
begin

  insert into aud_communities (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_commune,
    idf_community,
    idf_condominium,
    idf_province,
    idf_region,
    num_postal_code,
    num_unique_rol,
    txt_address,
    txt_check_digit,
    txt_community,
    txt_location
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_commune,
    old.idf_community,
    old.idf_condominium,
    old.idf_province,
    old.idf_region,
    old.num_postal_code,
    old.num_unique_rol,
    old.txt_address,
    old.txt_check_digit,
    old.txt_community,
    old.txt_location
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_communities
before update on dat_communities
for each row execute procedure action_before_update_communities ();