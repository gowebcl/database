truncate srv_parameters cascade;

insert into srv_parameters (idf_parameter, txt_key, txt_value) values
(1, 'num_aliquot_scale', '100000'),
(2, 'num_cutoff_day', '31');