drop function if exists environment_generic_exe_select;

create or replace function environment_generic_exe_select (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_boo_ascendant boolean;
    var_num_limit numeric;
    var_num_offset numeric;
    var_num_registries numeric;
    var_obj_filter json;
    var_obj_registries json;
    var_obj_row json;
    var_obj_search json;
    var_obj_sort json;
    var_txt_column text;
    var_txt_function text = 'environment_generic_exe_select';
    var_txt_sentence1 text;
    var_txt_sentence2 text;
    var_txt_sentence3 text;
    var_txt_sentence4 text;
    var_txt_sentence5 text;
    var_txt_sentence6 text;
    var_txt_table text;
    var_txt_search text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_num_limit = environment_core_get_json_numeric (incoming_object, 'num_limit');
    var_num_offset = environment_core_get_json_numeric (incoming_object, 'num_offset');
    var_obj_filter = environment_core_get_json_json (incoming_object, 'obj_filter');
    var_obj_search = environment_core_get_json_json (incoming_object, 'obj_search');
    var_obj_sort = environment_core_get_json_json (incoming_object, 'obj_sort');
    var_txt_table = environment_core_get_json_text (incoming_object, 'txt_table');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    var_txt_sentence1 = 'select array_to_json (array_agg (returned)) from (select * from ';
    var_txt_sentence1 = var_txt_sentence1 || var_txt_table;

    if (substring (var_txt_table, 1, 4) = 'dat_') then

        var_txt_sentence1 = var_txt_sentence1 || ' where sys_status = true ';

    else

        var_txt_sentence1 = var_txt_sentence1 || ' where true = true ';

    end if;

    var_txt_sentence2 = '';

    if (json_array_length (var_obj_search) is not null) then

        for var_obj_row in
            select
                json_array_elements (var_obj_search)
        loop

            var_txt_column = var_obj_row->>'txt_column';
            var_txt_search = var_obj_row->>'txt_search';

            var_txt_sentence2 = var_txt_sentence2 || var_txt_column;
            var_txt_sentence2 = var_txt_sentence2 || ' = ''' ;
            var_txt_sentence2 = var_txt_sentence2 || var_txt_search;
            var_txt_sentence2 = var_txt_sentence2 || ''' and ';

        end loop;

        var_txt_sentence2 = trim (' and ' || var_txt_sentence2);
        var_txt_sentence2 = substring (var_txt_sentence2, 0, length (var_txt_sentence2) - 3);

    end if;

    var_txt_sentence3 = '';

    if (json_array_length (var_obj_filter) is not null) then

        for var_obj_row in
            select
                json_array_elements (var_obj_filter)
        loop

            var_txt_column = var_obj_row->>'txt_column';
            var_txt_search = var_obj_row->>'txt_search';

            if (substring (var_txt_column, 1, 4) = 'idf_' or substring (var_txt_column, 1, 4) = 'num_') then

                var_txt_sentence3 = var_txt_sentence3 || var_txt_column;
                var_txt_sentence3 = var_txt_sentence3 || ' = ''' ;
                var_txt_sentence3 = var_txt_sentence3 || var_txt_search;
                var_txt_sentence3 = var_txt_sentence3 || ''' or ';

            else

                var_txt_sentence3 = var_txt_sentence3 || 'lower (';
                var_txt_sentence3 = var_txt_sentence3 || var_txt_column;
                var_txt_sentence3 = var_txt_sentence3 || ') like lower (''%' ;
                var_txt_sentence3 = var_txt_sentence3 || var_txt_search;
                var_txt_sentence3 = var_txt_sentence3 || '%'') or ';

            end if;

        end loop;

        var_txt_sentence3 = trim (' and (' || var_txt_sentence3);
        var_txt_sentence3 = substring (var_txt_sentence3, 0, length (var_txt_sentence3) - 2);
        var_txt_sentence3 = var_txt_sentence3 || ')';

    end if;

    var_txt_sentence4 = '';

    if (json_array_length (var_obj_sort) is not null) then

        var_txt_sentence4 = ' order by ';

        for var_obj_row in
            select
                json_array_elements (var_obj_sort)
        loop

            var_boo_ascendant = var_obj_row->>'boo_ascendant';
            var_txt_column = var_obj_row->>'txt_column';

            if (var_boo_ascendant is null) then

                var_boo_ascendant = false;

            end if;

            if (var_boo_ascendant is true) then

                var_txt_sentence4 = var_txt_sentence4 || var_txt_column;
                var_txt_sentence4 = var_txt_sentence4 || ', ' ;

            else

                var_txt_sentence4 = var_txt_sentence4 || var_txt_column;
                var_txt_sentence4 = var_txt_sentence4 || ' desc, ';

            end if;

        end loop;

        var_txt_sentence4 = substring (var_txt_sentence4, 0, length (var_txt_sentence4) - 1);

    end if;

    var_txt_sentence5 = '';

    if (var_num_limit is not null and var_num_offset is not null) then

        var_txt_sentence5 = var_txt_sentence5 || ' limit ';
        var_txt_sentence5 = var_txt_sentence5 || var_num_limit;
        var_txt_sentence5 = var_txt_sentence5 || ' offset ';
        var_txt_sentence5 = var_txt_sentence5 || var_num_offset;

    end if;

    var_txt_sentence6 = var_txt_sentence1 || var_txt_sentence2 || var_txt_sentence3 || var_txt_sentence4 ||  var_txt_sentence5 || ') returned';

    execute var_txt_sentence6 into var_obj_registries;

    outgoing_object = environment_core_set_json_json (outgoing_object, 'obj_registries', var_obj_registries);

    var_txt_sentence1 = 'select count (*) from ';
    var_txt_sentence1 = var_txt_sentence1 || var_txt_table;

    if (substring (var_txt_table, 1, 4) = 'dat_') then

        var_txt_sentence1 = var_txt_sentence1 || ' where sys_status = true ';

    else

        var_txt_sentence1 = var_txt_sentence1 || ' where true = true ';

    end if;

    var_txt_sentence3 = var_txt_sentence1 || var_txt_sentence2;

    execute var_txt_sentence3 into var_num_registries;

    outgoing_object = environment_core_set_json_numeric (outgoing_object, 'num_registries', var_num_registries);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;