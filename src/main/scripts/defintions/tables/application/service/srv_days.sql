drop table if exists srv_days cascade;

create table if not exists srv_days (
  idf_day numeric,
  txt_day text,
  constraint srv_days_pk primary key (idf_day)
);

comment on table srv_days is 'sdy';