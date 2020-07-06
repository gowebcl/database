drop sequence if exists seq_triggers cascade;
drop table if exists log_triggers cascade;

create table if not exists log_triggers (
  idf_trigger numeric,
  txt_trigger text,
  uid_trigger uuid,
  txt_timing text,
  txt_event text,
  txt_function text,
  txt_source text,
  idf_snapshot numeric,
  idf_table numeric,
  constraint log_triggers_pk primary key (idf_trigger),
  constraint log_triggers_fk1 foreign key (idf_snapshot) references log_snapshots (idf_snapshot),
  constraint log_triggers_fk2 foreign key (idf_table) references log_tables (idf_table)
) inherits (sys_default);

comment on table log_triggers is 'ltr';

create sequence if not exists seq_triggers
start with 1 increment by 1;

create or replace function action_before_insert_triggers ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_triggers
before insert on log_triggers
for each row execute procedure action_before_insert_triggers ();