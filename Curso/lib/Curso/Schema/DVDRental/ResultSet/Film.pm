package Curso::Schema::DVDRental::ResultSet::Film;
use utf8;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

=head2 listar

Método para buscar/consultar películas

=cut

sub listar {
  my ( $self, $params, $pagina, $filas ) = @_;
  my $filtros = {};

  $filtros->{ 'title' } = { 'ILIKE' => '%'.$params->{'titulo'}.'%' } if $params->{'titulo'};
  $filtros->{ 'film_categories.category_id' } = $params->{'categoria'} if $params->{'categoria'};

  return $self->search( $filtros, {
    page => $pagina,
    rows => $filas,
    order_by => 'title',
    join => [ 'film_categories' ],
  });
}

1;