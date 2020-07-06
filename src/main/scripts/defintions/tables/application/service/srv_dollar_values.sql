drop table if exists srv_dollar_values;

create table if not exists srv_dollar_values (
  idf_dollar_value numeric,
  num_value numeric,
  num_year numeric,
  num_month numeric,
  num_day numeric,
  num_type numeric,
  num_variation numeric,
  num_absolute numeric,
  num_percentage numeric,
  constraint srv_dollar_values_pk primary key (idf_dollar_value)
);

comment on table srv_dollar_values is 'sdv';