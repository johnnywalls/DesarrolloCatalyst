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

=head2 login

Acción para inicio de sesión autenticada

=cut

sub login : Local {
  my ( $self, $c ) = @_;
  use URI;
  use URI::QueryParam;

  my $params = $c->request->params;
  my $usuario = $params->{usuario};
  my $password = $params->{password};

  # Obtenemos la URI de la página desde donde se invocó a 'login',
  # para retornar a la misma página luego de la autenticación
  my $destino = $c->request->referer;
  $destino = $c->uri_for('/')->as_string unless $destino;
  $destino = URI->new($destino);
  # El parámetro 'mid' en la URI es usado por C::P::StatusMessage, y aquí
  # lo limpiamos para colocar nuestro propio mensaje
  $destino->query_param_delete('mid');

  if ( $usuario && $usuario ) {
    if ( $c->authenticate({ username => $usuario, password => $password, active => 1 } ) ) {
#       $c->log->debug( "Usuario autenticado con roles: " . join( ',', $c->user->roles ) );
      $destino->query_param_append( 'mid', $c->set_status_msg('¡Bienvenido(a), ' . $c->user->name . '!' ) );
      $c->response->redirect($destino->as_string);
    }
    else {
      $destino->query_param_append( 'mid', $c->set_error_msg('Credenciales inválidas' ) );
      $c->response->redirect($destino->as_string);
    }
  }
  else {
    $destino->query_param_append( 'mid', $c->set_error_msg('Parámetros inválidos' ) );
    $c->response->redirect($destino->as_string);
  }
}

=head2 logout

Acción para finalizar sesión de usuario autenticado

=cut

sub logout : Local {
  my ( $self, $c ) = @_;

  # Obtenemos la URI de la página desde donde se invocó a 'logout',
  # para retornar a la misma página luego de finalizar la sesión
  my $destino = $c->request->referer;
  $destino = $c->uri_for('/')->as_string unless $destino;
  $destino = URI->new($destino);
  # El parámetro 'mid' en la URI es usado por C::P::StatusMessage, y aquí
  # lo limpiamos para colocar nuestro propio mensaje
  $destino->query_param_delete('mid');

  if ( $c->user_exists ) {
    $c->logout;
    $destino->query_param_append( 'mid', $c->set_status_msg('Ha cerrado la sesión' ) );
    $c->response->redirect($destino->as_string);
  }
  else {
    $c->response->redirect($destino->as_string);
  }
}

=head1 AUTHOR

Juan Paredes,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
