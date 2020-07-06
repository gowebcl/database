drop trigger if exists trg_before_update_parameters on dat_parameters cascade;
drop trigger if exists trg_before_insert_parameters on dat_parameters cascade;
drop function if exists action_before_update_parameters cascade;
drop function if exists action_before_insert_parameters cascade;
drop sequence if exists seq_parameters cascade;
drop table if exists aud_parameters cascade;
drop table if exists dat_parameters cascade;

create table if not exists dat_parameters (
  idf_parameter numeric,
  idf_community numeric,
  txt_key text,
  txt_value text,
  constraint dat_parameters_pk primary key (idf_parameter),
  constraint dat_parameters_fk1 foreign key (idf_community) references dat_communities (idf_community)
) inherits (sys_default);

comment on table dat_parameters is 'par';

create table if not exists aud_parameters as
table dat_parameters with no data;

alter table aud_parameters
add constraint aud_parameters_fk0 foreign key (idf_parameter) references dat_parameters (idf_parameter),
add constraint aud_parameters_fk1 foreign key (idf_community) references dat_communities (idf_community);

create index if not exists aud_parameters_ix0 on aud_parameters (idf_parameter);
create index if not exists aud_parameters_ix1 on aud_parameters (idf_community);

create sequence if not exists seq_parameters
start with 1 increment by 1;

create or replace function action_before_insert_parameters ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_parameters
before insert on dat_parameters
for each row execute procedure action_before_insert_parameters ();

create or replace function action_before_update_parameters ()
returns trigger
as $body$
begin

  insert into aud_parameters (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_parameter,
    idf_community,
    txt_key,
    txt_value
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_parameter,
    old.idf_community,
    old.txt_key,
    old.txt_value
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_parameters
before update on dat_parameters
for each row execute procedure action_before_update_parameters ();