package Curso::Schema::DVDRental::Result::ReportePagosMensuales;
use utf8;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

# Se utiliza la clase de Vista (el ResultSource predeterminado correspondería a "tablas")
__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
# Es necesario dar un nombre de "tabla" (vista, en nuestro caso)
__PACKAGE__->table('reporte_pagos_mensuales');
# Activamos el atributo is_virtual para indicar que esta "vista" no estará en la BD
__PACKAGE__->result_source_instance->is_virtual(1);

# Definición de columnas / tipos de dato
__PACKAGE__->add_columns(
  "anio",
  { data_type => "integer" },
  "num_mes",
  { data_type => "integer" },
  "nombre_mes",
  { data_type => "varchar" },
  "total",
  { data_type => "numeric" },
);

# Definición SQL de la consulta. Opcionalmente podría tener parámetros, con comodines "?"

__PACKAGE__->result_source_instance->view_definition(q[
    SELECT
      EXTRACT(year FROM payment_date)::integer AS anio,
      TO_CHAR(payment_date, 'MM') AS num_mes,
      TO_CHAR(payment_date, 'Month') AS nombre_mes,
      SUM(amount) AS total
    FROM payment p
    WHERE
      payment_date BETWEEN 
        (?||' 00:00:00')::timestamp AND
        (?||' 23:59:59')::timestamp
    GROUP BY
      EXTRACT(year FROM payment_date),
      TO_CHAR(payment_date, 'MM'),
      TO_CHAR(payment_date, 'Month')
    ORDER BY 1, 2
]);

1;