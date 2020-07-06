drop sequence if exists seq_tables cascade;
drop table if exists log_tables cascade;

create table if not exists log_tables (
  idf_table numeric,
  txt_table text,
  uid_table uuid,
  txt_comment text,
  idf_snapshot numeric,
  constraint log_tables_pk primary key (idf_table),
  constraint log_tables_fk1 foreign key (idf_snapshot) references log_snapshots (idf_snapshot)
) inherits (sys_default);

comment on table log_tables is 'ltb';

create sequence if not exists seq_tables
start with 1 increment by 1;

create or replace function action_before_insert_tables ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_tables
before insert on log_tables
for each row execute procedure action_before_insert_tables ();