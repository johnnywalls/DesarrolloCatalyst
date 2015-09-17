package Curso::Controller::Root;
use Moose;
use namespace::autoclean;
use utf8;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

Curso::Controller::Root - Root Controller for Curso

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->log->debug("Acción index en controlador Root");
  $c->stash->{ template } = 'welcome.tt2';
  use Data::Dumper;
  $c->log->debug( "Menú Principal: " . Dumper( $c->config->{ menu_principal } ) );
  $c->log->debug( "Configuración activa: " . Dumper($c->config) );
  $c->session->{ inicio }++;
  $c->log->debug( "La página de inicio ha sido visitada " . $c->session->{ inicio } . " veces en esta sesión" );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
  my ( $self, $c ) = @_;
  $c->log->debug("Acción default en controlador Root");
  $c->response->body( '404: Página no encontrada' );
  $c->response->status(404);
}

=head2 begin

=cut

sub begin :Private {
  my ( $self, $c ) = @_;
  $c->log->debug("Acción begin en controlador Root");
}

=head2 auto

=cut

sub auto :Private {
  my ( $self, $c ) = @_;
  $c->log->debug("Acción auto en controlador Root");
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
  my ( $self, $c ) = @_;
  $c->log->debug("Acción end en controlador Root");
  $c->load_status_msgs;
}

=head2 configuracion

=cut

sub configuracion : Local {
  my ( $self, $c ) = @_;
  $c->response->body('Acceso denegado') unless $c->config->{ ver_configuracion };
}

=head2 invalidar_sesion

=cut

sub invalidar_sesion : Local {
  my ( $self, $c ) = @_;
  $c->delete_session;
  $c->response->redirect( $c->uri_for('/') );
}

=head1 AUTHOR

Juan Paredes,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
