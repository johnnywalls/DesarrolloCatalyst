package Curso::Controller::Peliculas;
use Moose;
use utf8;

use MooseX::MethodAttributes;
use Types::Standard qw/Int Str StrMatch/;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Curso::Controller::Peliculas - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 parametros_paginacion

Ejemplo de acción privada para obtener los parámetros de paginación
(número de página y fila) en listados, proporcionando valores predeterminados

=cut

sub parametros_paginacion : Private {
  my ( $self, $c ) = @_;

  my $pagina = $c->request->param('pagina');
  $pagina = 1 if (!$pagina || $pagina !~ /^\d+$/);

  my $filas = $c->request->param('filas');
  $filas = 25 if ( $pagina && (!$filas || $filas !~ /^\d+$/) );

  $c->stash( pagina => $pagina, filas => $filas );
}

=head2 index

Listado de películas

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  # Demostración sencilla de "stash" y su interpretación en plantilla
  $c->stash( saludo => '¡Bienvenido!' );
  $c->stash->{ usuario } = {
    nombre => 'Homero J. Simpson',
    email => 'homerj@example.com',
  };

  # Obtener lista de categorías para formulario de búsqueda
  my $categorias = $c->model('DVD::Category')->search( {} );
  $c->stash->{ categorias } = [ $categorias->all ];

  # Obtener parámetros de paginación
  $c->forward('parametros_paginacion');
  my $pagina = $c->stash->{ pagina };
  my $filas = $c->stash->{ filas };

  # Obtener parámetros de filtro, si existen
  my $filtros = {};

  $filtros->{ 'title' } = { 'ILIKE' => '%'.$c->req->param('titulo').'%' }
    if $c->req->param('titulo');

  $filtros->{ 'film_categories.category_id' } = $c->req->param('categoria')
    if $c->req->param('categoria');

  # Buscar películas en el modelo y pasar a la vista a través del stash
  my $resultados = $c->model('DVD::Film')->search( $filtros, {
    order_by => 'title',
    page => $pagina,
    rows => $filas,
    join => [ 'film_categories' ],
  });
  $c->stash->{ peliculas } = [ $resultados->all ];
  $c->stash->{ paginador } = $resultados->pager;
}


=head2 recientes

Ejemplo de acción con Path para indicar un mapping de URL distinto al nombre de la
subrutina

=cut

sub incorporacion_reciente : Path('recientes') {
  my ( $self, $c ) = @_;

  # Buscar películas recientes en el modelo y pasar a la vista a través del stash
  my $resultados = $c->model('DVD::Film')->search( {}, {
    order_by => 'release_year DESC, film_id DESC',
    rows => 10,
  });
  $c->stash->{ peliculas } = [ $resultados->all ];
  $c->stash->{ title } = 'Películas incorporadas recientemente';
  $c->stash->{ template } = 'peliculas/listado.tt2'; # Usamos una plantilla específica
}

=head2 documentales

Ejemplo de acción 'local': el nombre de la acción es equivalente al URL dentro del
controlador

=cut

sub documentales :Local { # equivalente a :Path('documentales')
  my ( $self, $c ) = @_;

  # Obtener parámetros de paginación
  $c->forward('parametros_paginacion');
  my $pagina = $c->stash->{ pagina };
  my $filas = $c->stash->{ filas };

  # Buscar películas en una categoría en el modelo y pasar a la vista a través del stash
  my $resultados = $c->model('DVD::Film')->search( { 'film_categories.category_id' => 6 }, {
    order_by => 'title',
    rows => $filas,
    page => $pagina,
    join => [ 'film_categories' ],
  });
  $c->stash->{ peliculas } = [ $resultados->all ];
  $c->stash->{ paginador } = $resultados->pager;
  $c->stash->{ title } = 'Documentales';
  $c->stash->{ template } = 'peliculas/listado.tt2'; # Usamos una plantilla específica
}

=head2 base

Acción base para cadena de acciones sobre una película dada

=cut

sub base : PathPart('peliculas') :Chained('/') : CaptureArgs(1) {
  my ( $self, $c, $film_id ) = @_;
  # En la acción base, capturamos el argumento y consultamos el film deseado
  # en el modelo, almacenándolo en el stash
  my $film = $c->model('DVD::Film')->find( $film_id );
  if ( $film ) {
    $c->stash->{ film } = $film;
  }
  else {
    $c->response->redirect( $c->uri_for('/peliculas') );
  }
}

=head2 detalle

Acción encadenada (punto final): consultar el detalle de una película

=cut

sub detalle :PathPart('') :Chained('base') :Args(0) {
  my ( $self, $c ) = @_;

  # Ya que el objeto 'film' se guardó en el stash en una acción anterior
  # de la cadena (en la base), podemos acceder a él sin buscar nuevamente
  # en el modelo
  my $film = $c->stash->{ film };

  # Obtener información de la existencia en tiendas del film seleccionado
  my @tiendas = map +{
      id => $_->get_column('store_id'),
      total => $_->get_column('total'),
      tienda => $c->model('DVD::Store')->find( $_->get_column('store_id') ),
    },
    $film->inventories->search({},{
      select => [ 'store_id', { 'count' => 'film_id' } ],
      as => [ 'store_id', 'total' ],
      group_by => 'store_id',
    })->all;
  $c->stash->{ tiendas } = \@tiendas;
}

=head2 alquileres_recientes

Acción encadenada (punto final): consultar alquileres recientes de una película

=cut

sub alquileres_recientes :PathPart('reciente') :Chained('base') :Args(0) {
  my ( $self, $c ) = @_;

  my $film = $c->stash->{ film };

  my @fechas = reverse map +{
      id => $_->rental_id,
      inicio => $_->rental_date,
      fin => $_->return_date,
    },
    $c->model('DVD::Rental')->search({
      'inventory.film_id' => $film->id,
    },{
      join => [ 'inventory' ],
      order_by => 'rental_date DESC',
      rows => 5,
    })->all;
  $c->stash->{ fechas_alquiler } = \@fechas;
}

=head2 tienda_base

Acción que sirve como eslabón intermedio en la cadena de acciones sobre una película dada
en una tienda específica

=cut

sub tienda_base : PathPart('tienda') :Chained('base') :CaptureArgs(1) {
  my ( $self, $c, $id_tienda ) = @_;
  my $film = $c->stash->{ film };
  my $tienda = $c->model('DVD::Store')->find( $id_tienda );
  if ( $tienda ) {
    $c->stash->{ tienda } = $tienda;
  }
  else {
    # Tienda no encontrada
    $c->response->redirect( $c->uri_for('/peliculas') );
  }
}

=head2 ver_disponibilidad_tienda

Consultar disponibilidad de una película dada en una tienda específica

=cut

sub ver_disponibilidad_tienda : PathPart('') :Chained('tienda_base') :Args(0) {
  my ( $self, $c ) = @_;

  my $film = $c->stash->{ film };
  my $tienda = $c->stash->{ tienda };

  my $existencia = $film->inventories->search({ store_id => $tienda->id },{
    select => [ { 'count' => 'film_id' } ],
    as => [ 'total' ],
  })->single->get_column('total');
  $c->stash->{ existencia } = $existencia;

  my $actualmente_alquiladas = $c->model('DVD::Rental')->search({
    inventory_id => { '-in' => $film->inventories->search({ store_id => $tienda->id })->get_column('inventory_id')->as_query },
    return_date => undef,
  },{
    select => [ { 'count' => 'rental_id' } ],
    as => [ 'actualmente_alquiladas' ],
  })->single->get_column('actualmente_alquiladas');
  $c->stash->{ disponibles } = $existencia - $actualmente_alquiladas;
}

=head2 alquilar

Acción para alquilar una película dada en una tienda específica

=cut

sub alquilar :Chained('tienda_base') :Args(0) {
  my ( $self, $c ) = @_;

  $c->forward('ver_disponibilidad_tienda');
}

=encoding utf8

=head1 AUTHOR

Juan Paredes,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
