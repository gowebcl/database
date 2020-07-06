drop trigger if exists trg_before_insert_traces on log_traces cascade;
drop function if exists action_before_insert_traces cascade;
drop sequence if exists seq_traces cascade;
drop table if exists log_traces cascade;

create table if not exists log_traces (
  idf_trace numeric,
  uid_trace uuid,
  txt_function text,
  idf_exception numeric,
  boo_defined boolean,
  obj_incoming json,
  obj_outgoing json,
  constraint log_traces_pk primary key (idf_trace)
) inherits (sys_default);

comment on table log_traces is 'trc';

create sequence if not exists seq_traces
start with 1 increment by 1;

create or replace function action_before_insert_traces ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_traces
before insert on log_traces
for each row execute procedure action_before_insert_traces ();