drop trigger if exists trg_before_insert_articles on dat_articles cascade;
drop function if exists action_before_insert_articles cascade;
drop sequence if exists seq_articles cascade;
drop table if exists dat_articles cascade;

create table if not exists dat_articles (
  idf_article numeric,
  txt_number text,
  txt_text text,
  idf_normative numeric,
  idf_title numeric,
  idf_chapter numeric,
  idf_paragraph numeric,
  constraint dat_articles_pk primary key (idf_article),
  constraint dat_articles_fk1 foreign key (idf_normative) references dat_normatives (idf_normative),
  constraint dat_articles_fk2 foreign key (idf_title) references dat_titles (idf_title),
  constraint dat_articles_fk3 foreign key (idf_chapter) references dat_chapters (idf_chapter),
  constraint dat_articles_fk4 foreign key (idf_paragraph) references dat_paragraphs (idf_paragraph)
) inherits (sys_default);

comment on table dat_articles is 'atc';

create sequence if not exists seq_articles
start with 1 increment by 1;

create or replace function action_before_insert_articles ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_articles
before insert on dat_articles
for each row execute procedure action_before_insert_articles ();