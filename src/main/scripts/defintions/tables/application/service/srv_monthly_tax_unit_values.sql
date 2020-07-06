drop table if exists srv_monthly_tax_unit_values;

create table if not exists srv_monthly_tax_unit_values (
  idf_monthly_tax_unit_value numeric,
  num_value numeric,
  num_year numeric,
  num_month numeric,
  num_variation numeric,
  num_absolute numeric,
  num_percentage numeric,
  constraint srv_monthly_tax_unit_values_pk primary key (idf_monthly_tax_unit_value)
);

comment on table srv_monthly_tax_unit_values is 'smv';