drop sequence if exists seq_columns cascade;
drop table if exists log_columns cascade;

create table if not exists log_columns (
  idf_column numeric,
  txt_column text,
  uid_column uuid,
  num_position numeric,
  txt_type text,
  boo_null boolean,
  idf_snapshot numeric,
  idf_table numeric,
  constraint log_columns_pk primary key (idf_column),
  constraint log_columns_fk1 foreign key (idf_snapshot) references log_snapshots (idf_snapshot),
  constraint log_columns_fk2 foreign key (idf_table) references log_tables (idf_table)
) inherits (sys_default);

comment on table log_columns is 'lcl';

create sequence if not exists seq_columns
start with 1 increment by 1;

create or replace function action_before_insert_columns ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_columns
before insert on log_columns
for each row execute procedure action_before_insert_columns ();