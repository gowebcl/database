drop table if exists srv_payments cascade;

/* TRANSACTIONS */

create table if not exists srv_transactions (
  idf_transaction numeric,
  txt_transaction text,
  constraint srv_transactions_pk primary key (idf_transaction)
);

comment on table srv_transactions is 'stx';

/* PAYMENTS */

create table if not exists srv_payments (
  idf_payment numeric,
  txt_payment text,
  constraint srv_payments_pk primary key (idf_payment)
);

comment on table srv_payments is 'spy';