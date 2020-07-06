drop trigger if exists trg_before_insert_titles on dat_titles cascade;
drop function if exists action_before_insert_titles cascade;
drop sequence if exists seq_titles cascade;
drop table if exists dat_titles cascade;

create table if not exists dat_titles (
  idf_title numeric,
  txt_number text,
  txt_text text,
  idf_normative numeric,
  constraint dat_titles_pk primary key (idf_title),
  constraint dat_titles_fk1 foreign key (idf_normative) references dat_normatives (idf_normative)
) inherits (sys_default);

comment on table dat_titles is 'ttl';

create sequence if not exists seq_titles
start with 1 increment by 1;

create or replace function action_before_insert_titles ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_titles
before insert on dat_titles
for each row execute procedure action_before_insert_titles ();