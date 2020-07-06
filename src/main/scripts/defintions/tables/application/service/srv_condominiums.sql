drop table if exists srv_condominiums cascade;

create table if not exists srv_condominiums (
  idf_condominium numeric,
  txt_condominium text,
  constraint srv_condominiums_pk primary key (idf_condominium)
);

comment on table srv_condominiums is 'sco';