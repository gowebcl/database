drop table if exists srv_profiles cascade;

create table if not exists srv_profiles (
  idf_profile numeric,
  txt_profile text,
  constraint srv_profiles_pk primary key (idf_profile)
);

comment on table srv_profiles is 'spr';