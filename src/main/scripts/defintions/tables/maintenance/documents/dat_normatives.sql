drop trigger if exists trg_before_insert_normatives on dat_normatives cascade;
drop function if exists action_before_insert_normatives cascade;
drop sequence if exists seq_normatives cascade;
drop table if exists dat_normatives cascade;

create table if not exists dat_normatives (
  idf_normative numeric,
  txt_id text,
  txt_modification text,
  txt_organism text,
  txt_promulgation text,
  txt_publication text,
  txt_rule text,
  txt_title text,
  txt_url text,
  txt_validity text,
  txt_version text,
  constraint dat_normatives_pk primary key (idf_normative)
) inherits (sys_default);

comment on table dat_normatives is 'nmt';

create sequence if not exists seq_normatives
start with 1 increment by 1;

create or replace function action_before_insert_normatives ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_normatives
before insert on dat_normatives
for each row execute procedure action_before_insert_normatives ();