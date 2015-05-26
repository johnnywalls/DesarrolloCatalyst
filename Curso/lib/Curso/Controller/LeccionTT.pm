package Curso::Controller::LeccionTT;
use Moose;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Curso::Controller::LeccionTT - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->stash( cadena => '¡Bienvenido!' );
  $c->stash->{ hash } = {
    nombre => 'Homero J. Simpson',
    email => 'homerj@example.com',
    direccion => '742 Evergreen Terrace',
  };
  $c->stash->{ lista } = [ qw/ Homero Bart Lisa Marge Bart Maggie Abraham / ];
  $c->stash->{ lista_hashes } = [
    { titulo => 'Star Wars', id => 1 },
    { titulo => 'The Lord of the Rings', id => 2 },
    { titulo => 'The Shining', id => 3 },
  ];
}

=head2 bloques

=cut

sub bloques : Local {
  my ( $self, $c ) = @_;

  $c->stash->{ peliculas } = [ $c->model('DVD::Film')->search({},
    { rows => 4, order_by => \'random()' })->all ];
  $c->stash->{ categorias } = [ $c->model('DVD::Category')->search({})->all ];

}

=head2 filtros

=cut

sub filtros : Local {
  my ( $self, $c ) = @_;

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
