drop sequence if exists seq_constraints cascade;
drop table if exists log_constraints cascade;

create table if not exists log_constraints (
  idf_constraint numeric,
  txt_constraint text,
  uid_constraint uuid,
  idf_snapshot numeric,
  idf_table numeric,
  idf_column numeric,
  idf_foreign_table numeric,
  idf_foreign_column numeric,
  constraint log_constraints_pk primary key (idf_constraint),
  constraint log_constraints_fk1 foreign key (idf_snapshot) references log_snapshots (idf_snapshot),
  constraint log_constraints_fk2 foreign key (idf_table) references log_tables (idf_table),
  constraint log_constraints_fk3 foreign key (idf_column) references log_columns (idf_column),
  constraint log_constraints_fk4 foreign key (idf_foreign_table) references log_tables (idf_table),
  constraint log_constraints_fk5 foreign key (idf_foreign_column) references log_columns (idf_column)
) inherits (sys_default);

comment on table log_constraints is 'lct';

create sequence if not exists seq_constraints
start with 1 increment by 1;

create or replace function action_before_insert_constraints ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_constraints
before insert on log_constraints
for each row execute procedure action_before_insert_constraints ();