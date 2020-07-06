truncate srv_profiles cascade;

insert into srv_profiles (idf_profile, txt_profile) values
(0, 'Super Administrador'),
(11, 'Administrador'),
(21, 'Mayordomo'),
(31, 'Conserje'),
(41, 'Propietario'),
(51, 'Residente'),
(61, 'Proveedor');