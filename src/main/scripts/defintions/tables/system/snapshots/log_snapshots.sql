drop sequence if exists seq_snapshots cascade;
drop table if exists log_snapshots cascade;

create table if not exists log_snapshots (
  idf_snapshot numeric,
  uid_snapshot uuid,
  txt_version text,
  constraint log_snapshots_pk primary key (idf_snapshot)
) inherits (sys_default);

comment on table log_snapshots is 'lss';

create sequence if not exists seq_snapshots
start with 1 increment by 1;

create or replace function action_before_insert_snapshots ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_snapshots
before insert on log_snapshots
for each row execute procedure action_before_insert_snapshots ();