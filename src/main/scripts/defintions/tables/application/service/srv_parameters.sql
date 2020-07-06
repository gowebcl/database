drop table if exists srv_parameters cascade;

create table if not exists srv_parameters (
  idf_parameter numeric,
  txt_key text,
  txt_value text,
  constraint srv_parameters_pk primary key (idf_parameter)
);

comment on table srv_parameters is 'spa';