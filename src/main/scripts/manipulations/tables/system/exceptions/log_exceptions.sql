truncate log_traces cascade;
truncate log_exceptions cascade;

/* EXCEPTIONS */

insert into log_exceptions (idf_exception, txt_exception) values
(-1, 'Token no válido'),
(0, 'Resultado exitoso'),
(1, 'Excepción no definida'),
(2, 'Error no controlado'),
(11001, 'Usuario ya existe en el sistema'),
(11002, 'Usuario no existe en el sistema'),
(11003, 'Usuario y/o Contraseña no válidos'),
(11004, 'Comunidad ya existe en el sistema'),
(11005, 'No hay comunidades creadas en el sistema'),
(11006, 'Comunidad no existe en el sistema'),
(11007, 'Unidad ya existe en el sistema'),
(11008, 'Clasificación de cuenta incogruente'),
(11011, 'Unidad no existe en el sistema');