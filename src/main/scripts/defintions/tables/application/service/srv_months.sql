drop table if exists srv_months cascade;

create table if not exists srv_months (
  idf_month numeric,
  txt_month text,
  constraint srv_months_pk primary key (idf_month)
);

comment on table srv_months is 'smt';