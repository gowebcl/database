drop sequence if exists seq_parameters cascade;
drop table if exists log_parameters cascade;

create table if not exists log_parameters (
  idf_parameter numeric,
  txt_parameter text,
  uid_parameter uuid,
  num_position numeric,
  txt_type text,
  txt_direction text,
  idf_snapshot numeric,
  idf_function numeric,
  constraint log_parameters_pk primary key (idf_parameter),
  constraint log_parameters_fk1 foreign key (idf_snapshot) references log_snapshots (idf_snapshot),
  constraint log_parameters_fk2 foreign key (idf_function) references log_functions (idf_function)
) inherits (sys_default);

comment on table log_parameters is 'lpr';

create sequence if not exists seq_parameters
start with 1 increment by 1;

create or replace function action_before_insert_parameters ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_parameters
before insert on log_parameters
for each row execute procedure action_before_insert_parameters ();