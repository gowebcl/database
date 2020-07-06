drop table if exists srv_positions cascade;

create table if not exists srv_positions (
  idf_position numeric,
  txt_position text,
  constraint srv_positions_pk primary key (idf_position)
);

comment on table srv_positions is 'spo';