package Curso::Controller::Root;
use Moose;
use namespace::autoclean;
use utf8;
use URI;
use URI::QueryParam;

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
  $c->session->{ inicio }++;
  # demostrar diferentes niveles de mensajes para bitácora
  $c->log->info( "La página de inicio ha sido visitada " . $c->session->{ inicio } . " veces en esta sesión" );
  $c->log->warn( "Esta es una advertencia" );
  $c->log->error( "Esto es un mensaje de error" );
  $c->log->fatal( "Mensaje fatal" );
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

  # Agregamos información de IP, URL y usuario a la bitácora
  Log::Log4perl::MDC->put("ip", $c->request->address);
  Log::Log4perl::MDC->put("url", $c->request->uri->as_string );
  if ( $c->user_exists ) {
    Log::Log4perl::MDC->put("user", $c->user->username);
  }
  else {
    Log::Log4perl::MDC->put("user", 'anonimo');
  }

  # Acciones que no requieren un usuario autenticado
  return 1 if ($c->req->path eq 'login' || $c->req->path eq '' );

  if ( $c->user_exists ) {
    # Podemos limitar el acceso a RapidApp desde la propia aplicación
    if ( $c->req->path eq 'admin-ra' ) {
      if ( $c->check_any_user_role( qw/Administrator/ ) ) {
        return 1;
      }
      else {
        $c->detach('/acceso_denegado');
        return 0;
      }
    }
    else {
      return 1;
    }
  }
  else {
    # En caso de requerir inicio de sesión, iremos a la página de inicio
    my $destino = $c->uri_for('/')->as_string;
    $destino = URI->new($destino);
    # El parámetro 'mid' en la URI es usado por C::P::StatusMessage, y aquí
    # lo limpiamos para colocar nuestro propio mensaje
    $destino->query_param_delete('mid');

    $destino->query_param_append( 'mid', $c->set_error_msg('Por favor, ingrese sus credenciales') );
    $c->response->redirect($destino->as_string);
    return 0;
  }
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

=head2 login

Acción para inicio de sesión autenticada

=cut

sub login : Local {
  my ( $self, $c ) = @_;

  my $params = $c->request->params;
  my $usuario = $params->{usuario};
  my $password = $params->{password};

  # Luego de autenticar, iremos a la página de inicio
  my $destino = $c->uri_for('/')->as_string;
  $destino = URI->new($destino);
  # El parámetro 'mid' en la URI es usado por C::P::StatusMessage, y aquí
  # lo limpiamos para colocar nuestro propio mensaje
  $destino->query_param_delete('mid');

  if ( $usuario && $usuario ) {
    if ( $c->authenticate({ username => $usuario, password => $password, active => 1 } ) ) {
      $c->log->debug( "Usuario autenticado con roles: " . join( ',', $c->user->roles ) );
      $destino->query_param_append( 'mid', $c->set_status_msg('¡Bienvenido(a), ' . $c->user->cn . '!' ) );
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
  $c->stash->{ template } = 'welcome.tt2';
  $c->logout;
  $c->delete_session;
  $c->response->redirect( $c->uri_for( '/', { mid => $c->set_status_msg('Ha cerrado la sesión' ) } ) );
}

=head2 acceso_denegado

Mostrar mensaje en caso de privilegios insuficientes para alguna acción

=cut

sub acceso_denegado : Private {
  my ( $self, $c ) = @_;
  $c->stash->{ error_msg } = 'Privilegios insuficientes';
  $c->stash->{ template } = 'acceso_denegado.tt2';
  return 0;
}

=head1 AUTHOR

Juan Paredes,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
