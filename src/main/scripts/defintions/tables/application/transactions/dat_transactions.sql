drop trigger if exists trg_before_update_transactions on dat_transactions cascade;
drop trigger if exists trg_before_insert_transactions on dat_transactions cascade;
drop function if exists action_before_update_transactions cascade;
drop function if exists action_before_insert_transactions cascade;
drop sequence if exists seq_transactions cascade;
drop table if exists aud_transactions cascade;
drop table if exists dat_transactions cascade;

create table if not exists dat_transactions (
  idf_transaction numeric,
  idf_transaction_type numeric,
  num_amount numeric,
  tim_transaction timestamp,
  idf_community numeric,
  idf_category numeric,
  idf_subcategory numeric,
  idf_account numeric,
  constraint dat_transactions_pk primary key (idf_transaction),
  constraint dat_transactions_fk1 foreign key (idf_community) references dat_communities (idf_community),
  constraint dat_transactions_fk2 foreign key (idf_category) references dat_categories (idf_category),
  constraint dat_transactions_fk3 foreign key (idf_subcategory) references dat_subcategories (idf_subcategory),
  constraint dat_transactions_fk4 foreign key (idf_account) references dat_accounts (idf_account)
) inherits (sys_default);

comment on table dat_transactions is 'trx';

create table if not exists aud_transactions as
table dat_transactions with no data;

alter table aud_transactions
add constraint aud_transactions_fk0 foreign key (idf_transaction) references dat_transactions (idf_transaction),
add constraint aud_transactions_fk1 foreign key (idf_community) references dat_communities (idf_community),
add constraint aud_transactions_fk2 foreign key (idf_category) references dat_categories (idf_category),
add constraint aud_transactions_fk3 foreign key (idf_subcategory) references dat_subcategories (idf_subcategory);

create index if not exists aud_transactions_ix0 on aud_transactions (idf_transaction);

create sequence if not exists seq_transactions
start with 1 increment by 1;

create or replace function action_before_insert_transactions ()
returns trigger
as $body$
begin

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_status = true;
  new.sys_version = 0;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_insert_transactions
before insert on dat_transactions
for each row execute procedure action_before_insert_transactions ();

create or replace function action_before_update_transactions ()
returns trigger
as $body$
begin

  insert into aud_transactions (
    sys_timestamp,
    sys_status,
    sys_user,
    sys_version,
    idf_category,
    idf_community,
    idf_subcategory,
    idf_transaction,
    idf_transaction_type,
    num_amount,
    tim_transaction
  ) values (
    old.sys_timestamp,
    old.sys_status,
    old.sys_user,
    old.sys_version,
    old.idf_category,
    old.idf_community,
    old.idf_subcategory,
    old.idf_transaction,
    old.idf_transaction_type,
    old.num_amount,
    old.tim_transaction
  );

  new.sys_timestamp = environment_core_get_current_timestamp ();
  new.sys_version = old.sys_version + 1;

  return new;

end;
$body$ language plpgsql;

create trigger trg_before_update_transactions
before update on dat_transactions
for each row execute procedure action_before_update_transactions ();