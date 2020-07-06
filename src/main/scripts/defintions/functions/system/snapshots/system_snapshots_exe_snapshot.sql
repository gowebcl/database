drop function if exists system_snapshots_exe_snapshot;

create or replace function system_snapshots_exe_snapshot (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_snapshot numeric;
    var_idf_column numeric;
    var_idf_constraint numeric;
    var_idf_function numeric;
    var_idf_parameter numeric;
    var_idf_sequence numeric;
    var_idf_table numeric;
    var_idf_trigger numeric;
    var_rec_column record;
    var_rec_constraint record;
    var_rec_function record;
    var_rec_parameter record;
    var_rec_sequence record;
    var_rec_table record;
    var_rec_trigger record;
    var_txt_comment text;
    var_txt_function text = 'system_documentation_exe_snapshot';
    var_txt_scheme text;
    var_txt_version text;
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_snapshot = environment_core_get_next_sequence ('seq_snapshots');
    var_txt_scheme = environment_core_get_json_text (incoming_object, 'txt_scheme');
    var_txt_version = environment_core_get_json_text (incoming_object, 'txt_version');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    insert into log_snapshots (
        idf_snapshot,
        uid_snapshot,
        txt_version
    ) values (
        var_idf_snapshot,
        uuid_generate_v4 (),
        var_txt_version
    );

    for var_rec_table in
        select
            table_name "txt_table"
        from
            information_schema.tables
        where
            table_schema = var_txt_scheme
        order by
            table_name
    loop

        var_idf_table = environment_core_get_next_sequence ('seq_tables');

        select
            dct.description
        into
            var_txt_comment
        from
            pg_namespace nsp,
            pg_class cls,
            pg_description dct
        where
            nsp.nspname = var_txt_scheme
            and cls.relnamespace = nsp.oid
            and cls.relname = var_rec_table.txt_table
            and dct.objoid = cls.oid;

        insert into log_tables (
            idf_table,
            txt_table,
            uid_table,
            txt_comment,
            idf_snapshot
        ) values (
            var_idf_table,
            var_rec_table.txt_table,
            uuid_generate_v4 (),
            var_txt_comment,
            var_idf_snapshot
        );

        for var_rec_column in
            select
                column_name "txt_column",
                data_type "txt_type",
                ordinal_position "num_position",
                is_nullable "boo_null"
            from
                information_schema.columns
            where
                table_schema = var_txt_scheme
                and table_name = var_rec_table.txt_table
            order by
                ordinal_position
        loop

            var_idf_column = environment_core_get_next_sequence ('seq_columns');

            insert into log_columns (
                idf_column,
                txt_column,
                uid_column,
                num_position,
                txt_type,
                boo_null,
                idf_snapshot,
                idf_table
            ) values (
                var_idf_column,
                var_rec_column.txt_column,
                uuid_generate_v4 (),
                var_rec_column.num_position,
                var_rec_column.txt_type,
                var_rec_column.boo_null::boolean,
                var_idf_snapshot,
                var_idf_table
            );

        end loop;

        for var_rec_trigger in
            select
                trg.trigger_name "txt_trigger",
                lower (trg.action_timing) "txt_timing",
                lower (trg.event_manipulation) "txt_event",
                rou.routine_name "txt_function",
                rou.routine_definition "txt_source"
            from
                information_schema.triggers trg,
                information_schema.routines rou
            where
                trg.trigger_schema = var_txt_scheme
                and trg.event_object_table = var_rec_table.txt_table
                and rou.routine_name = substr (trg.action_statement, 19, char_length (trg.action_statement) - 20)
            order by
                trg.trigger_name
        loop

            var_idf_trigger = environment_core_get_next_sequence ('seq_triggers');

            insert into log_triggers (
                idf_trigger,
                txt_trigger,
                uid_trigger,
                txt_timing,
                txt_event,
                txt_function,
                txt_source,
                idf_snapshot,
                idf_table
            ) values (
                var_idf_trigger,
                var_rec_trigger.txt_trigger,
                uuid_generate_v4 (),
                var_rec_trigger.txt_timing,
                var_rec_trigger.txt_event,
                var_rec_trigger.txt_function,
                var_rec_trigger.txt_source,
                var_idf_snapshot,
                var_idf_table
            );

        end loop;

    end loop;

    for var_rec_table in
        select
            txt_table
        from
            log_tables
        where
            idf_snapshot = var_idf_snapshot
        order by
            txt_table
    loop

        for var_rec_constraint in
            select
                cst.constraint_name "txt_constraint",
                lower (cst.constraint_type) "txt_type",
                lcl1.idf_column "idf_column",
                ltb2.idf_table "idf_foreign_table",
                lcl2.idf_column "idf_foreign_column"
            from
                information_schema.table_constraints cst,
                information_schema.key_column_usage kcu,
                information_schema.constraint_column_usage ccu,
                log_tables ltb1,
                log_columns lcl1,
                log_tables ltb2,
                log_columns lcl2
            where
                cst.constraint_schema = var_txt_scheme
                and kcu.constraint_name = cst.constraint_name
                and ccu.constraint_name = cst.constraint_name
                and cst.table_name = var_rec_table.txt_table
                and ltb1.idf_snapshot = var_idf_snapshot
                and ltb1.txt_table = cst.table_name
                and lcl1.idf_table = ltb1.idf_table
                and lcl1.txt_column = kcu.column_name
                and ltb2.idf_snapshot = ltb1.idf_snapshot
                and ltb2.txt_table = ccu.table_name
                and lcl2.idf_table = ltb2.idf_table
                and lcl2.txt_column = ccu.column_name
            order by
                cst.constraint_type desc,
                cst.constraint_name
        loop

            var_idf_constraint = environment_core_get_next_sequence ('seq_constraints');

            insert into log_constraints (
                idf_constraint,
                txt_constraint,
                uid_constraint,
                idf_snapshot,
                idf_table,
                idf_column,
                idf_foreign_table,
                idf_foreign_column
            ) values (
                var_idf_constraint,
                var_rec_constraint.txt_constraint,
                uuid_generate_v4 (),
                var_idf_snapshot,
                var_idf_table,
                var_rec_constraint.idf_column,
                var_rec_constraint.idf_foreign_table,
                var_rec_constraint.idf_foreign_column
            );

        end loop;

    end loop;

    for var_rec_sequence in
        select
            sequence_name "txt_sequence",
            start_value "nun_start",
            increment "nun_increment"
        from
            information_schema.sequences
        where
            sequence_schema = var_txt_scheme
        order by
            sequence_name
    loop

        var_idf_sequence = environment_core_get_next_sequence ('seq_sequences');

        insert into log_sequences (
            idf_sequence,
            uid_sequence,
            txt_sequence,
            nun_start,
            nun_increment,
            idf_snapshot
        ) values (
            var_idf_sequence,
            uuid_generate_v4 (),
            var_rec_sequence.txt_sequence,
            var_rec_sequence.nun_start::numeric,
            var_rec_sequence.nun_increment::numeric,
            var_idf_snapshot
        );

    end loop;

    for var_rec_function in
        select
            routine_name "txt_function",
            data_type "txt_type",
            routine_definition "txt_source"
        from
            information_schema.routines
        where
            routine_schema = var_txt_scheme
            and data_type <> 'trigger'
            and routine_definition is not null
        order by
            routine_name
    loop

        var_idf_function = environment_core_get_next_sequence ('seq_functions');

        insert into log_functions (
            idf_function,
            txt_function,
            uid_function,
            txt_type,
            txt_source,
            idf_snapshot
        ) values (
            var_idf_function,
            var_rec_function.txt_function,
            uuid_generate_v4 (),
            var_rec_function.txt_type,
            var_rec_function.txt_source,
            var_idf_snapshot
        );

        for var_rec_parameter in
            select
            parameter_name "txt_parameter",
            ordinal_position "num_position",
            data_type "txt_type",
            parameter_mode "txt_direction"
        from
            information_schema.parameters
        where
            specific_schema = var_txt_scheme
            and substr (specific_name, 1, char_length (specific_name) - 7) = var_rec_function.txt_function
        order by
            ordinal_position
        loop

            var_idf_parameter = environment_core_get_next_sequence ('seq_parameters');

            insert into log_parameters (
                idf_parameter,
                txt_parameter,
                uid_parameter,
                num_position,
                txt_type,
                txt_direction,
                idf_snapshot,
                idf_function
            ) values (
                var_idf_parameter,
                var_rec_parameter.txt_parameter,
                uuid_generate_v4 (),
                var_rec_parameter.num_position,
                var_rec_parameter.txt_type,
                var_rec_parameter.txt_direction,
                var_idf_snapshot,
                var_idf_function
            );

        end loop;

    end loop;

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;