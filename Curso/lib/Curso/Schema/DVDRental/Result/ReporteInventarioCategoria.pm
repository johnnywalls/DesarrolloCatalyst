package Curso::Schema::DVDRental::Result::ReporteInventarioCategoria;
use utf8;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

# Se utiliza la clase de Vista (el ResultSource predeterminado correspondería a "tablas")
__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
# Es necesario dar un nombre de "tabla" (vista, en nuestro caso)
__PACKAGE__->table('reporte_inventario');
# Activamos el atributo is_virtual para indicar que esta "vista" no estará en la BD
__PACKAGE__->result_source_instance->is_virtual(1);

# Definición de columnas / tipos de dato
__PACKAGE__->add_columns(
  "categoria",
  { data_type => "varchar" },
  "ejemplares_inventario",
  { data_type => "integer" },
  "ejemplares_en_alquiler",
  { data_type => "integer" },
);

# Definición SQL de la consulta. Opcionalmente podría tener parámetros, con comodines "?"

__PACKAGE__->result_source_instance->view_definition(q[
  SELECT
  c.name AS categoria,
  count(i.film_id) AS ejemplares_inventario,
  count(r.rental_id) AS ejemplares_en_alquiler
  FROM category c LEFT JOIN film_category fc USING (category_id)
  LEFT JOIN film f USING (film_id)
  LEFT JOIN inventory i USING (film_id)
  LEFT JOIN rental r ON (r.inventory_id = i.inventory_id AND r.return_date IS NULL)
  GROUP BY c.name
  ORDER BY 2 DESC, 2
]);

1;