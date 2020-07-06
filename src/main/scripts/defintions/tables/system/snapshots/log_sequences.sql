drop sequence if exists seq_sequences cascade;
drop table if exists log_sequences cascade;

create table if not exists log_sequences (
  idf_sequence numeric,
  uid_sequence uuid,
  txt_sequence text,
  nun_start numeric,
  nun_increment numeric,
  idf_snapshot numeric,
  constraint log_sequences_pk primary key (idf_sequence),
  constraint log_sequences_fk1 foreign key (idf_snapshot) references log_snapshots (idf_snapshot)
) inherits (sys_default);

comment on table log_sequences is 'lsq';

create sequence if not exists seq_sequences
start with 1 increment by 1;

create or replace function action_before_insert_sequences ()
returns trigger as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_sequences
before insert on log_sequences
for each row execute procedure action_before_insert_sequences ();