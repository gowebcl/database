drop function if exists application_configurations_get_account;

create or replace function application_configurations_get_account (
    in incoming_object json
)
returns json as $body$
declare
    outgoing_object json;
    var_idf_community numeric;
    var_obj_account json;
    var_obj_accounts json;
    var_obj_categories json;
    var_obj_category json;
    var_obj_subcategories json;
    var_obj_subcategory json;
    var_rec_account record;
    var_rec_category record;
    var_rec_subcategory record;
    var_txt_function text = 'application_configurations_get_account';
    var_sys_failed numeric;
    var_sys_success numeric;
    var_sys_user numeric;
begin

    var_sys_failed = environment_core_get_result_failed ();
    var_sys_success = environment_core_get_result_success ();
    perform environment_core_get_function_validation (incoming_object);

    var_idf_community = environment_core_get_json_numeric (incoming_object, 'idf_community');
    var_sys_user = environment_core_get_json_numeric (incoming_object, 'sys_user');

    var_obj_categories = environment_core_set_json_empty ();

    for var_rec_category in
        select
            idf_category,
            txt_category
        from
            dat_categories
        where
            sys_status = true
            and idf_community = var_idf_community
        order by
            txt_category
    loop

        var_obj_subcategories = environment_core_set_json_empty ();

        for var_rec_subcategory in
            select
                idf_category,
                idf_subcategory,
                txt_subcategory
            from
                dat_subcategories
            where
                sys_status = true
                and idf_category = var_rec_category.idf_category
            order by
                txt_subcategory
        loop

            var_obj_accounts = environment_core_set_json_empty ();

            for var_rec_account in
                select
                    idf_category,
                    idf_subcategory,
                    idf_account,
                    txt_account
                from
                    dat_accounts
                where
                    sys_status = true
                    and idf_subcategory = var_rec_subcategory.idf_subcategory
                order by
                    txt_account
            loop

                select
                    array_to_json (
                        array_agg (returned)
                    )
                into
                    var_obj_account
                from (
                    select
                        var_rec_account.idf_category,
                        var_rec_account.idf_subcategory,
                        var_rec_account.idf_account,
                        var_rec_account.txt_account
                ) returned;

                var_obj_accounts = environment_core_set_json_json (var_obj_accounts, 'obj_account', var_obj_account);

            end loop;

            select
                array_to_json (
                    array_agg (returned)
                )
            into
                var_obj_subcategory
            from (
                select
                    var_rec_subcategory.idf_category,
                    var_rec_subcategory.idf_subcategory,
                    var_rec_subcategory.txt_subcategory,
                    var_obj_accounts "obj_accounts"
            ) returned;

            var_obj_subcategories = environment_core_set_json_json (var_obj_subcategories, 'obj_subcategory', var_obj_subcategory);

        end loop;

        select
            array_to_json (
                array_agg (returned)
            )
        into
            var_obj_category
        from (
            select
                var_rec_category.idf_category,
                var_rec_category.txt_category,
                var_obj_subcategories "obj_subcategories"
        ) returned;

        var_obj_categories = environment_core_set_json_json (var_obj_categories, 'obj_category', var_obj_category);

    end loop;

    outgoing_object = environment_core_set_json_json (outgoing_object, 'obj_categories', var_obj_categories);

    return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_success, incoming_object, outgoing_object);

exception
    when others then
        return environment_core_get_function_result (var_sys_user, var_txt_function, var_sys_failed, incoming_object, outgoing_object);

end;
$body$ language plpgsql;