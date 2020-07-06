drop trigger if exists trg_before_insert_chapters on dat_chapters cascade;
drop function if exists action_before_insert_chapters cascade;
drop sequence if exists seq_chapters cascade;
drop table if exists dat_chapters cascade;

create table if not exists dat_chapters (
  idf_chapter numeric,
  txt_number text,
  txt_text text,
  idf_normative numeric,
  idf_title numeric,
  constraint dat_chapters_pk primary key (idf_chapter),
  constraint dat_chapters_fk1 foreign key (idf_normative) references dat_normatives (idf_normative),
  constraint dat_chapters_fk2 foreign key (idf_title) references dat_titles (idf_title)
) inherits (sys_default);

comment on table dat_chapters is 'cht';

create sequence if not exists seq_chapters
start with 1 increment by 1;

create or replace function action_before_insert_chapters ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_chapters
before insert on dat_chapters
for each row execute procedure action_before_insert_chapters ();