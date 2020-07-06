drop trigger if exists trg_before_insert_paragraphs on dat_paragraphs cascade;
drop function if exists action_before_insert_paragraphs cascade;
drop sequence if exists seq_paragraphs cascade;
drop table if exists dat_paragraphs cascade;

create table if not exists dat_paragraphs (
  idf_paragraph numeric,
  txt_number text,
  txt_text text,
  idf_normative numeric,
  idf_title numeric,
  idf_chapter numeric,
  constraint dat_paragraphs_pk primary key (idf_paragraph),
  constraint dat_paragraphs_fk1 foreign key (idf_normative) references dat_normatives (idf_normative),
  constraint dat_paragraphs_fk2 foreign key (idf_title) references dat_titles (idf_title),
  constraint dat_paragraphs_fk3 foreign key (idf_chapter) references dat_chapters (idf_chapter)
) inherits (sys_default);

comment on table dat_paragraphs is 'prg';

create sequence if not exists seq_paragraphs
start with 1 increment by 1;

create or replace function action_before_insert_paragraphs ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_paragraphs
before insert on dat_paragraphs
for each row execute procedure action_before_insert_paragraphs ();