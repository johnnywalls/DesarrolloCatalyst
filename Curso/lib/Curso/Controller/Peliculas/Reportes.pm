package Curso::Controller::Peliculas::Reportes;
use Moose;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Curso::Controller::Peliculas::Reportes - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->log->debug('Acción index en controlador Peliculas::Reportes');
  $c->stash->{ message } = 'Esta es la acción index en Peliculas::Reportes';
}

=head2 begin

=cut

sub begin: Private {
  my ( $self, $c ) = @_;

  $c->log->debug('Acción begin en controlador Peliculas::Reportes');
}

=head2 auto

=cut

sub auto: Private {
  my ( $self, $c ) = @_;

  $c->log->debug('Acción auto en controlador Peliculas::Reportes');
}

=head2 end

=cut

sub end: Private {
  my ( $self, $c ) = @_;

  $c->log->debug('Acción end en controlador Peliculas::Reportes');

  # Para ilustrar, utilizaremos la acción end para que todas las acciones de este
  # controlador utilicen una Vista diferente (TTSite), con una plantilla específica
  unless ( $c->response->content_type ) {
      $c->response->content_type('text/html; charset=utf-8');
  }
  $c->stash->{ template } = 'message.tt2';
  $c->forward('Curso::View::TT::TTSite');
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
