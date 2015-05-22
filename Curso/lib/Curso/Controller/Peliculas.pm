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

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  # Demostración sencilla de "stash" y su interpretación en plantilla
  $c->stash( saludo => '¡Bienvenido!' );
  $c->stash->{ usuario } = {
    nombre => 'Homero J. Simpson',
    email => 'homerj@example.com',
  };
  $c->stash->{ peliculas } = [
    { title => 'Star Wars', id => 1 },
    { title => 'The Lord of the Rings', id => 2 },
  ];
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
