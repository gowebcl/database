do $$
declare
    var_num_offset numeric;
    var_num_range numeric;
    var_rec_community record;
    var_rec_subcategory record;
    var_txt_incoming text;
begin

    for var_rec_community in
        select
            idf_community
        from
            dat_communities
        where
            sys_status = true
            and idf_community <> 1
    loop

        for var_rec_subcategory in
            select
                ctg.idf_category,
                stg.idf_subcategory
            from
                dat_categories ctg,
                dat_subcategories stg
            where
                ctg.idf_community = var_rec_community.idf_community
                and ctg.sys_status = true
                and stg.idf_category = ctg.idf_category
                and stg.sys_status = true
            order by
                ctg.txt_category,
                stg.txt_subcategory
        loop

            var_num_range = environment_core_get_random_numeric (1);

            for var_num_offset in
                1 .. var_num_range
            loop

                var_txt_incoming = '{';
                var_txt_incoming = var_txt_incoming || '"sys_user": 0,';
                var_txt_incoming = var_txt_incoming || '"idf_community": ' || var_rec_community.idf_community || ',';
                var_txt_incoming = var_txt_incoming || '"idf_category": ' || var_rec_subcategory.idf_category || ',';
                var_txt_incoming = var_txt_incoming || '"idf_subcategory": ' || var_rec_subcategory.idf_subcategory || ',';
                var_txt_incoming = var_txt_incoming || '"txt_account": "' || environment_core_get_random_text (15) || '"';
                var_txt_incoming = var_txt_incoming || '}';

                perform application_configurations_set_account (var_txt_incoming::json);

            end loop;

        end loop;

    end loop;

end $$;