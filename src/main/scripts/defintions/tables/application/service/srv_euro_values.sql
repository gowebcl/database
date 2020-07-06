drop table if exists srv_euro_values;

create table if not exists srv_euro_values (
  idf_euro_value numeric,
  num_value numeric,
  num_year numeric,
  num_month numeric,
  num_day numeric,
  num_type numeric,
  num_variation numeric,
  num_absolute numeric,
  num_percentage numeric,
  constraint srv_euro_values_pk primary key (idf_euro_value)
);

comment on table srv_euro_values is 'sev';