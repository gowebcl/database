drop table if exists log_exceptions cascade;

create table if not exists log_exceptions (
  idf_exception numeric,
  txt_exception text,
  constraint log_exceptions_pk primary key (idf_exception)
);

comment on table log_exceptions is 'exc';