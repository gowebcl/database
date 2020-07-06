drop extension if exists "uuid-ossp" cascade;
drop extension if exists "pgcrypto" cascade;
drop schema if exists public cascade;

create schema if not exists public;
create extension if not exists "pgcrypto";
create extension if not exists "uuid-ossp";