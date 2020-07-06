drop sequence if exists seq_functions cascade;
drop table if exists log_functions cascade;

create table if not exists log_functions (
  idf_function numeric,
  txt_function text,
  uid_function uuid,
  txt_type text,
  txt_source text,
  idf_snapshot numeric,
  constraint log_functions_pk primary key (idf_function),
  constraint log_functions_fk1 foreign key (idf_snapshot) references log_snapshots (idf_snapshot)
) inherits (sys_default);

comment on table log_functions is 'lfc';

create sequence if not exists seq_functions
start with 1 increment by 1;

create or replace function action_before_insert_functions ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_functions
before insert on log_functions
for each row execute procedure action_before_insert_functions ();