drop sequence if exists seq_indexes cascade;
drop table if exists log_indexes cascade;

create table if not exists log_indexes (
  idf_index numeric,
  txt_index text,
  uid_index uuid,
  txt_source text,
  idf_snapshot numeric,
  idf_table numeric,
  constraint log_indexes_pk primary key (idf_index),
  constraint log_indexes_fk1 foreign key (idf_snapshot) references log_snapshots (idf_snapshot),
  constraint log_indexes_fk2 foreign key (idf_table) references log_tables (idf_table)
) inherits (sys_default);

comment on table log_indexes is 'lix';

create sequence if not exists seq_indexes
start with 1 increment by 1;

create or replace function action_before_insert_indexes ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_indexes
before insert on log_indexes
for each row execute procedure action_before_insert_indexes ();