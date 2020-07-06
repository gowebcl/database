truncate srv_subcategories cascade;

insert into srv_subcategories (idf_subcategory, txt_subcategory, idf_category) values
(11, 'Remuneraciones', 1),
(12, 'Anticipos', 1),
(13, 'Honorarios', 1),
(14, 'Leyes Sociales', 1),
(21, 'Consumos Básicos', 2),
(22, 'Seguridad', 2),
(31, 'Mantenciones', 3),
(32, 'Materiales', 3),
(41, 'Reparaciones', 4),
(42, 'Materiales', 4),
(51, 'Artículos de Aseo', 5),
(52, 'Artículos de Oficina', 5),
(53, 'Otros', 5);