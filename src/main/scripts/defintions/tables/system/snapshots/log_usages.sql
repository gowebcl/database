drop sequence if exists seq_usages cascade;
drop table if exists log_usages cascade;

create table if not exists log_usages (
  idf_usage numeric,
  uid_usage uuid,
  idf_table numeric,
  idf_column numeric,
  constraint log_usages_pk primary key (idf_usage),
  constraint log_usages_fk1 foreign key (idf_table) references log_tables (idf_table),
  constraint log_usages_fk2 foreign key (idf_column) references log_columns (idf_column)
) inherits (sys_default);

comment on table log_usages is 'lug';

create sequence if not exists seq_usages
start with 1 increment by 1;

create or replace function action_before_insert_usages ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_usages
before insert on log_usages
for each row execute procedure action_before_insert_usages ();