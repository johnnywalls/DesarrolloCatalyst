package Curso::Controller::Peliculas;
use Moose;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Curso::Controller::Peliculas - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


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

  # Obtener parámetros de paginación, y proporcionar valores predeterminados
  my $pagina = $c->request->param('pagina');
  $pagina = 1 if (!$pagina || $pagina !~ /^\d+$/);
  my $filas = $c->request->param('filas');
  $filas = 25 if ( $pagina && (!$filas || $filas !~ /^\d+$/) );

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

Ejemplo de acción

=cut

sub recientes :Local {
  my ( $self, $c ) = @_;

  $c->response->body('Mostrar listado de películas recientes');
}

=head2 populares

Ejemplo de acción

=cut

sub populares :Local {
  my ( $self, $c ) = @_;

  $c->response->body('Mostrar listado de películas más populares');
}

=head2 detalle

Ejemplo de acción

=cut

sub detalle :Local :Args(1) {
  my ( $self, $c, $id ) = @_;

  $c->response->body("Mostrar detalle de película # $id");
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
