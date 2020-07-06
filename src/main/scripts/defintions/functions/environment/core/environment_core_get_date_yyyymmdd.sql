drop function if exists environment_core_get_date_yyyymmdd;

create or replace function environment_core_get_date_yyyymmdd (
    in in_txt_date text
)
returns numeric as $body$
begin

    return to_char (in_txt_date::date, 'yyyymmdd')::numeric;

end;
$body$ language plpgsql;